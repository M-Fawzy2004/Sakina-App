import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Elevated tactile frosted glass card featuring specular backdrop filter,
/// 1px hairline gold border stroke, and clean surface presentation without harsh shadows.
class TactileGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const TactileGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(20.r);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            splashColor: AppColors.goldGlowSoft,
            highlightColor: Colors.transparent,
            child: Container(
              padding: padding ?? EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.frostedGlass,
                borderRadius: effectiveRadius,
                border: Border.all(
                  color: borderColor ?? AppColors.goldBorderStroke,
                  width: 1.r,
                ),
                boxShadow: boxShadow,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
