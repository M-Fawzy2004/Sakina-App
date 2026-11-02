import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class HisnCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const HisnCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;

          return InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              HapticService.selectionClick();
              onSelectCategory(cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.16)
                    : colors.surfaceElevated,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? colors.accentGold : colors.borderHairline,
                  width: isSelected ? 1.4.r : 1.r,
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: isSelected ? colors.accentGold : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

