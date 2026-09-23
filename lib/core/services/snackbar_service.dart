import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/router/app_router.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class SnackbarService {
  void showMessage(String message, {bool isError = false}) {
    final context = AppRouter.scaffoldMessengerKey.currentContext;
    if (context == null) return;

    final color = isError ? Colors.red : Colors.green;

    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    AppRouter.scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showError(String message) => showMessage(message, isError: true);

  void showSuccess(String message) => showMessage(message, isError: false);

  void handleDioError(DioException error) {
    final context = AppRouter.scaffoldMessengerKey.currentContext;
    if (context == null) return;

    final l10n = AppLocalizations.of(context)!;
    String message = l10n.authErrorUnknown;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = l10n.authErrorTimeout;
    } else if (error.type == DioExceptionType.connectionError) {
      message = l10n.authErrorNoInternet;
    } else if (error.type == DioExceptionType.badResponse) {
      final status = error.response?.statusCode ?? 0;
      if (status >= 500) {
        message =
            l10n.authErrorRequestFailed; // maps to Server Error generic message
      } else if (status == 401 || status == 403) {
        message = l10n.authErrorUnauthorized;
      }
    }

    showError(message);
  }
}
