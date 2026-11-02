import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class HisnSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const HisnSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(
              Iconsax.search_normal_1,
              size: 18.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                  fontSize: 13.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث في أبواب وأدعية حصن المسلم...',
                  hintStyle: AppTextStyles.captionOf(context).copyWith(
                    color: colors.textSecondary,
                    fontSize: 12.sp,
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
                  size: 18.r,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  controller.clear();
                  onClear();
                },
              )
            else
              SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}

