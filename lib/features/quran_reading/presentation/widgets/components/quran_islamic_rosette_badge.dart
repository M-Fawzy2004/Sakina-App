import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Eight-pointed Islamic star badge (Rub El Hizb / Rosette - ۞)
/// containing the golden Ayah number:
/// Formed by combining a rotated 45° rounded square and an inner concentric circle.
class QuranIslamicRosetteBadge extends StatelessWidget {
  final int number;
  final bool isHighlighted;

  const QuranIslamicRosetteBadge({
    super.key,
    required this.number,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isHighlighted
        ? AppColors.emeraldGlow
        : AppColors.champagneGold;

    return Container(
      width: 45.r,
      height: 45.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotated square to form 8-pointed star
          Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: 26.r,
              height: 26.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: activeColor.withValues(alpha: 0.65),
                  width: 1.r,
                ),
              ),
            ),
          ),

          // Inner circle
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.obsidianCore,
              border: Border.all(color: activeColor, width: 1.2.r),
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.caption.copyWith(
                  color: activeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
