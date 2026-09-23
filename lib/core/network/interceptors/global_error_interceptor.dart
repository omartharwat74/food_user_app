import 'package:dio/dio.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';

class GlobalErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // We only want to globally handle unexpected errors like Timeouts,
    // No Internet, or 500 Server Errors.
    // 400, 422 (Form Validation) should be handled by the UI/Cubit locally.

    bool shouldShowGlobalError = false;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      shouldShowGlobalError = true;
    } else if (err.type == DioExceptionType.badResponse) {
      final status = err.response?.statusCode ?? 0;
      // Show global error for 500+ Server Errors
      // Exclude 400-499 which are usually client/validation errors
      if (status >= 500) {
        shouldShowGlobalError = true;
      }
    } else if (err.type == DioExceptionType.unknown) {
      shouldShowGlobalError = true;
    }

    if (shouldShowGlobalError) {
      // Use our globally injected SnackbarService to show the localized error
      sl<SnackbarService>().handleDioError(err);
    }

    // Continue propagating the error so Cubits/UseCases also receive the Failure
    // (They will receive it and can choose to ignore it or stop loading spinners)
    super.onError(err, handler);
  }
}
