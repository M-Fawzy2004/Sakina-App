import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Draggable modal top handle.
class ReaderDragHandle extends StatelessWidget {
  const ReaderDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.champagneGold.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Sheet Header with Calligraphy title, settings icon, and reset to defaults action.
class ReaderSheetHeader extends StatelessWidget {
  final Color accentColor;
  final Color secondaryTextColor;
  final VoidCallback? onResetToDefault;

  const ReaderSheetHeader({
    super.key,
    required this.accentColor,
    required this.secondaryTextColor,
    this.onResetToDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Iconsax.setting_2, color: accentColor, size: 20.r),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'إِعْدَادَاتُ المَصْحَفِ الشَّرِيفِ',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        if (onResetToDefault != null)
          InkWell(
            onTap: onResetToDefault,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 0.8.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.rotate_left,
                    size: 13.r,
                    color: accentColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'الافتراضي',
                    style: AppTextStyles.caption.copyWith(
                      color: accentColor,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Text(
            'تَخْصِيصُ القِرَاءَةِ',
            style: AppTextStyles.caption.copyWith(
              color: secondaryTextColor,
              fontSize: 11.sp,
            ),
          ),
      ],
    );
  }
}

/// Section title widget with leading icon and stylized Arabic typography.
class ReaderSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;

  const ReaderSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: accentColor),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 13.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}

