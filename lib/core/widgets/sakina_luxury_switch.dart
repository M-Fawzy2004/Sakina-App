import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Ultra-compact, luxury tactile toggle switch designed exclusively for Sakina.
///
/// Features:
/// - Zero external padding / margins (fits perfectly inside custom tiles).
/// - Refined compact footprint (~38w x 22h).
/// - Directionality-aware smooth sliding animation (RTL/LTR compatible).
/// - Strictly ZERO drop shadows to honor the app's clean architectural luxury aesthetic.
/// - Integrated tactile haptic feedback.
class SakinaLuxurySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final double? width;
  final double? height;

  const SakinaLuxurySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.width,
    this.height,
  });

  static const Duration _animationDuration = Duration(milliseconds: 220);
  static const Curve _animationCurve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedWidth = width ?? 38.w;
    final resolvedHeight = height ?? 22.h;
    final thumbPadding = 2.5.r;
    final thumbSize = resolvedHeight - (thumbPadding * 2);

    final resolvedActiveTrack = activeTrackColor ?? colors.accentGold;
    final resolvedInactiveTrack = inactiveTrackColor ?? colors.surfaceElevated;

    final resolvedActiveThumb = activeThumbColor ??
        (isDark ? const Color(0xFF141414) : Colors.white);
    final resolvedInactiveThumb = inactiveThumbColor ??
        colors.textSecondary.withValues(alpha: 0.7);

    final resolvedActiveBorder = activeBorderColor ??
        colors.accentGold.withValues(alpha: 0.8);
    final resolvedInactiveBorder = inactiveBorderColor ??
        colors.borderHairline.withValues(alpha: 0.6);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticService.selectionClick();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        width: resolvedWidth,
        height: resolvedHeight,
        padding: EdgeInsets.all(thumbPadding),
        decoration: BoxDecoration(
          color: value ? resolvedActiveTrack : resolvedInactiveTrack,
          borderRadius: BorderRadius.circular(resolvedHeight / 2),
          border: Border.all(
            color: value ? resolvedActiveBorder : resolvedInactiveBorder,
            width: 0.9.r,
          ),
        ),
        child: AnimatedAlign(
          duration: _animationDuration,
          curve: _animationCurve,
          alignment: value
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: value ? resolvedActiveThumb : resolvedInactiveThumb,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

