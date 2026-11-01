import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Eight-pointed Islamic star badge (Rub El Hizb / Rosette - ۞)
/// containing the golden Ayah number:
/// Formed by combining a rotated 45° rounded square and an inner concentric circle.
/// Proportionately scales with font size adjustments so the ayah numeral remains crisp and prominent.
class QuranIslamicRosetteBadge extends StatelessWidget {
  final int number;
  final bool isHighlighted;
  final double? size;
  final Color? color;
  final Color? backgroundColor;

  const QuranIslamicRosetteBadge({
    super.key,
    required this.number,
    this.isHighlighted = false,
    this.size,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ??
        (isHighlighted ? AppColors.emeraldGlow : AppColors.champagneGold);
    final innerBg = backgroundColor ??
        (context.isDark ? AppColors.obsidianCore : context.colors.cardSurface);

    final effectiveSize = size ?? 32.r;
    final innerDimension = effectiveSize * 0.76;
    final digitCount = number.toString().length;
    final fontSize = digitCount >= 3
        ? (effectiveSize * 0.34).sp
        : (effectiveSize * 0.42).sp;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotated square to form the 8-pointed Islamic rosette star
          Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: innerDimension,
              height: innerDimension,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: activeColor.withValues(alpha: 0.65),
                  width: 1.1.r,
                ),
              ),
            ),
          ),

          // Inner concentric circle with subtle background
          Container(
            width: innerDimension,
            height: innerDimension,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: innerBg,
              border: Border.all(
                color: activeColor,
                width: 1.2.r,
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.cairo(
                  color: activeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
