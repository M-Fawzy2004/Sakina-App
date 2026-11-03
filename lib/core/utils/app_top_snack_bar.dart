import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/router/app_router.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Centralized, top-anchored floating toast & notification system for Sakina.
/// Positions feedback messages gracefully at the top of the viewport (below the status bar/notch),
/// strictly floating above modal sheets, bottom navigation bars, and dialogs with safe area immunity.
abstract final class AppTopSnackBar {
  static OverlayEntry? _activeEntry;
  static Timer? _activeTimer;

  /// Dismisses any currently visible top notification immediately.
  static void dismiss() {
    _activeTimer?.cancel();
    _activeTimer = null;
    _activeEntry?.remove();
    _activeEntry = null;
  }

  /// Shows a standardized top-anchored notification with high-contrast text,
  /// safe area protection (preventing notch/camera overlap), and a dismiss action.
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Dismiss any previous toast to prevent stacking
    dismiss();

    HapticFeedback.lightImpact();

    final overlay = Overlay.maybeOf(context, rootOverlay: true) ??
        rootNavigatorKey.currentState?.overlay;

    if (overlay == null) {
      // Safe fallback for edge environments without an overlay
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
      return;
    }

    final bg = backgroundColor ?? AppColors.carbonSlate;
    final stroke = borderColor ?? AppColors.champagneGold;
    final fg = textColor ?? AppColors.pureChalk;
    final ico = iconColor ?? stroke;
    final effectiveIcon = icon ?? Iconsax.info_circle;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _TopToastWidget(
        message: message,
        icon: effectiveIcon,
        iconColor: ico,
        backgroundColor: bg,
        borderColor: stroke,
        textColor: fg,
        onDismiss: dismiss,
      ),
    );

    _activeEntry = entry;
    overlay.insert(entry);

    _activeTimer = Timer(duration, () {
      if (_activeEntry == entry) {
        dismiss();
      }
    });
  }

  /// Convenience shortcut for success notifications (emerald accents).
  static void showSuccess({
    required BuildContext context,
    required String message,
    IconData icon = Iconsax.tick_circle,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      icon: icon,
      borderColor: AppColors.emeraldGlow,
      iconColor: AppColors.emeraldGlow,
      duration: duration,
    );
  }

  /// Convenience shortcut for error or warning notifications.
  static void showError({
    required BuildContext context,
    required String message,
    IconData icon = Iconsax.warning_2,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      icon: icon,
      borderColor: AppColors.errorRed,
      iconColor: AppColors.errorRed,
      duration: duration,
    );
  }
}

class _TopToastWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the true hardware status bar height from the native FlutterView
    // to prevent any collision with the camera punch hole, notch, or clock
    final view = View.maybeOf(context);
    final hardwareTop =
        view != null ? view.padding.top / view.devicePixelRatio : 0.0;
    final mediaTop = MediaQuery.maybePaddingOf(context)?.top ?? 0.0;
    final statusBarHeight = math.max(hardwareTop, mediaTop);

    // Guaranteed clearance below status bar, notch, and punch-hole camera
    final safeTop =
        (statusBarHeight > 0 ? math.max(statusBarHeight, 36.h) : 44.h) + 12.h;

    return Positioned(
      top: safeTop,
      left: 16.w,
      right: 16.w,
      child: Material(
        type: MaterialType.transparency,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1.0 - value) * -22.h),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta != null &&
                    details.primaryDelta! < -3) {
                  onDismiss();
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 40.h,
                  maxHeight: 52.h,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.85),
                    width: 1.r,
                  ),
                ),
                child: Row(
                  children: [
                    // Status Icon
                    Icon(
                      icon,
                      color: iconColor,
                      size: 19.r,
                    ),
                    SizedBox(width: 9.w),

                    // Message Content (Crisp, High-Contrast Text)
                    Expanded(
                      child: Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Dismiss / Delete Action Button
                    InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onDismiss();
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Iconsax.close_circle,
                          size: 18.r,
                          color: textColor.withValues(alpha: 0.6),
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
