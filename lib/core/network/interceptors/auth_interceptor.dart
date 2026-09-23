import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/api_endpoints.dart';
import '../../storage/token_storage.dart';
import '../../router/app_router.dart';
import '../../router/route_names.dart';

/// A record holding a pending request that arrived while a token refresh was
/// already in flight.
typedef _PendingRequest = ({
  RequestOptions options,
  ErrorInterceptorHandler handler,
});

/// Attaches `Authorization: Bearer <token>` to every non-public request and
/// implements a strict Mutex / Queue pattern for 401 token-refresh retries.
///
/// When a 401 occurs:
/// - The first failure sets [_isRefreshing] = true and fires the refresh call.
/// - Every subsequent concurrent 401 is pushed into [_requestsQueue] and waits.
/// - On success: all queued requests are retried with the new token.
/// - On failure: all queued requests are rejected and the user is logged out.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, {required this.getDio});

  final TokenStorage _tokenStorage;

  /// Returns the main application [Dio] instance (used only to read [BaseOptions]).
  final Dio Function() getDio;

  // ── Mutex state ──────────────────────────────────────────────────────────────
  bool _isRefreshing = false;
  final List<_PendingRequest> _requestsQueue = [];

  // ── Helpers ──────────────────────────────────────────────────────────────────
  bool _isPublicAuthPath(String path) {
    for (final publicPath in ApiEndpoints.publicAuthPaths) {
      if (path == publicPath || path.endsWith(publicPath)) return true;
    }
    return false;
  }

  String? _normalizeAccessToken(String? token) {
    final trimmed = token?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    const prefix = 'Bearer ';
    if (trimmed.toLowerCase().startsWith(prefix.toLowerCase())) {
      return trimmed.substring(prefix.length).trim();
    }
    return trimmed;
  }

  // ── onRequest ─────────────────────────────────────────────────────────────────
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.uri.path;
    final isPublic = _isPublicAuthPath(path) || _isPublicAuthPath(options.path);

    if (!isPublic) {
      final raw = await _tokenStorage.getAccessToken();
      final token = _normalizeAccessToken(raw);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    _logAuthDebug('→ ${options.method} ${options.path} | public=$isPublic');
    return handler.next(options);
  }

  // ── onError ───────────────────────────────────────────────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final bodyStatus = err.response?.data is Map
        ? err.response?.data['status']
        : null;
    final isUnauthorized = status == 401 || bodyStatus == 401;

    // Only handle 401s
    if (!isUnauthorized) {
      return handler.next(err);
    }

    // If the failing request IS the refresh endpoint or auth endpoint → logout immediately
    final failedPath = err.requestOptions.path;
    if (failedPath == ApiEndpoints.refreshToken ||
        failedPath.endsWith(ApiEndpoints.refreshToken)) {
      _logAuthDebug('Refresh endpoint returned 401 → logging out');
      await _handleLogout(err);
      return handler.next(err);
    }

    // ── MUTEX CHECK ────────────────────────────────────────────────────────────
    if (_isRefreshing) {
      // Another refresh is already in flight → queue this request and WAIT
      _logAuthDebug('Refresh in progress – queuing request: $failedPath');
      _requestsQueue.add((options: err.requestOptions, handler: handler));
      return; // Do NOT call handler.next / resolve here; it will be resolved later
    }

    // ── FIRST 401 → ACQUIRE LOCK AND REFRESH OR LOGOUT ─────────────────────────
    _isRefreshing = true;
    _logAuthDebug('Token invalid/expired (401) for: $failedPath');

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _logAuthDebug('No refresh token stored → logging out');
      _isRefreshing = false;
      await _rejectQueue(err);
      await _handleLogout(err);
      return handler.next(err);
    }

    // Use a CLEAN Dio instance – zero interceptors – to call the refresh endpoint
    final cleanDio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    try {
      final refreshResponse = await cleanDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = refreshResponse.data;
      String? newAccessToken;
      String? newRefreshToken;

      if (data is Map<String, dynamic>) {
        // Try common response shapes: data.data.accessToken or data.accessToken
        final inner = data['data'] ?? data;
        if (inner is Map<String, dynamic>) {
          newAccessToken = inner['accessToken']?.toString();
          newRefreshToken = inner['refreshToken']?.toString();
        }
      }

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw Exception('Refresh response did not contain a valid accessToken');
      }

      // ── SUCCESS ──────────────────────────────────────────────────────────────
      await _tokenStorage.saveAccessToken(newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(newRefreshToken);
      }

      _logAuthDebug('Token refreshed successfully');
      _isRefreshing = false;

      // Retry the original failed request
      final retryDio = _buildRetryDio();
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await retryDio.fetch(err.requestOptions);
      handler.resolve(retryResponse);

      // Drain the queue
      await _resolveQueue(newAccessToken);
    } catch (e) {
      // ── FAILURE ──────────────────────────────────────────────────────────────
      _logAuthDebug('Token refresh FAILED: $e');
      _isRefreshing = false;
      await _rejectQueue(err);
      await _handleLogout(err);
      handler.next(err);
    }
  }

  // ── Queue helpers ─────────────────────────────────────────────────────────────

  /// Retry every queued request with the newly obtained [newToken].
  Future<void> _resolveQueue(String newToken) async {
    final pending = List<_PendingRequest>.from(_requestsQueue);
    _requestsQueue.clear();

    final retryDio = _buildRetryDio();
    for (final req in pending) {
      try {
        req.options.headers['Authorization'] = 'Bearer $newToken';
        _logAuthDebug('Retrying queued: ${req.options.path}');
        final response = await retryDio.fetch(req.options);
        req.handler.resolve(response);
      } on DioException catch (e) {
        req.handler.next(e);
      } catch (e) {
        req.handler.next(DioException(requestOptions: req.options, error: e));
      }
    }
  }

  /// Reject every queued request with [err].
  Future<void> _rejectQueue(DioException err) async {
    final pending = List<_PendingRequest>.from(_requestsQueue);
    _requestsQueue.clear();
    for (final req in pending) {
      req.handler.next(
        DioException(
          requestOptions: req.options,
          response: err.response,
          type: err.type,
          error: err.error,
        ),
      );
    }
  }

  /// A minimal Dio instance used solely to re-execute failed requests.
  /// It does NOT include the AuthInterceptor to avoid infinite loops.
  Dio _buildRetryDio() {
    final mainDio = getDio();
    final retryDio = Dio(mainDio.options);
    for (final interceptor in mainDio.interceptors) {
      if (interceptor is! AuthInterceptor) {
        retryDio.interceptors.add(interceptor);
      }
    }
    return retryDio;
  }

  Future<void> _handleLogout(DioException err) async {
    await _tokenStorage.clearAccessToken();
    await _tokenStorage.clearRefreshToken();
    AppRouter.router.go(RouteNames.authEntry);
  }
}

void _logAuthDebug(String message) {
  if (kDebugMode) {
    debugPrint('[AUTH] $message');
  }
}
