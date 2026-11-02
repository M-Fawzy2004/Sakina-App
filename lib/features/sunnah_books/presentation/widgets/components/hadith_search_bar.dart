import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class HadithSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;
  final bool hasActiveChapter;

  const HadithSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    required this.hasActiveChapter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Icon(
                    Iconsax.search_normal_1,
                    size: 17.r,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textPrimary,
                        fontSize: 12.5.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث في نصوص الأحاديث...',
                        hintStyle: AppTextStyles.captionOf(context).copyWith(
                          color: colors.textSecondary,
                          fontSize: 11.5.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        size: 16.r,
                        color: colors.textSecondary,
                      ),
                      onPressed: () {
                        controller.clear();
                        onClear();
                      },
                    )
                  else
                    SizedBox(width: 10.w),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () {
              HapticService.selectionClick();
              onFilterTap();
            },
            child: Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: hasActiveChapter
                    ? colors.accentGold.withValues(alpha: 0.16)
                    : colors.cardSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: hasActiveChapter ? colors.accentGold : colors.borderHairline,
                  width: hasActiveChapter ? 1.4.r : 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.candle_2,
                  size: 18.r,
                  color: hasActiveChapter ? colors.accentGold : colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

