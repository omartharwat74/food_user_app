import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/router/app_router.dart';
import 'package:food_user_app/core/theme/app_colors.dart';

OverlayEntry? _currentTopSnackBarEntry;
Timer? _currentTopSnackBarTimer;

/// Displays an animated SnackBar from the top of the screen.
/// Always rendered in the root overlay above bottom sheets and soft keyboards.
void showTopSnackBar(
  BuildContext context,
  String message, {
  bool isError = true,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 3),
}) {
  _currentTopSnackBarTimer?.cancel();
  _currentTopSnackBarTimer = null;

  try {
    _currentTopSnackBarEntry?.remove();
  } catch (_) {}
  _currentTopSnackBarEntry = null;

  final overlay = Overlay.maybeOf(context, rootOverlay: true) ??
      AppRouter.router.routerDelegate.navigatorKey.currentState?.overlay ??
      (AppRouter.scaffoldMessengerKey.currentContext != null
          ? Overlay.maybeOf(
              AppRouter.scaffoldMessengerKey.currentContext!,
              rootOverlay: true,
            )
          : null);

  if (overlay == null) return;

  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _TopSnackBarOverlayWidget(
      message: message,
      isError: isError,
      backgroundColor: backgroundColor,
      duration: duration,
      onDismissed: () {
        if (_currentTopSnackBarEntry == entry) {
          try {
            entry.remove();
          } catch (_) {}
          _currentTopSnackBarEntry = null;
        }
      },
    ),
  );

  _currentTopSnackBarEntry = entry;
  overlay.insert(entry);
}

class _TopSnackBarOverlayWidget extends StatefulWidget {
  const _TopSnackBarOverlayWidget({
    required this.message,
    required this.isError,
    this.backgroundColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final bool isError;
  final Color? backgroundColor;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_TopSnackBarOverlayWidget> createState() =>
      _TopSnackBarOverlayWidgetState();
}

class _TopSnackBarOverlayWidgetState extends State<_TopSnackBarOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    _timer?.cancel();
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final backgroundColor = widget.backgroundColor ??
        (widget.isError
            ? const Color(0xFFD32F2F)
            : AppColors.success);
    final iconData = widget.isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _dismiss,
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! < -4) {
                _dismiss();
              }
            },
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _dismiss,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
