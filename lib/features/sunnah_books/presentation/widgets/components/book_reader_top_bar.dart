import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class BookReaderTopBar extends StatelessWidget {
  final String titleAr;
  final String subtitle;
  final bool isSearchOpen;
  final VoidCallback onToggleSearch;
  final VoidCallback onOpenChapters;

  const BookReaderTopBar({
    super.key,
    required this.titleAr,
    required this.subtitle,
    required this.isSearchOpen,
    required this.onToggleSearch,
    required this.onOpenChapters,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // Fixed Back Button
          InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () {
              HapticService.selectionClick();
              Navigator.of(context).pop();
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 20.r,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Book Title & Chapter Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleAr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMediumOf(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionOf(context).copyWith(
                    fontSize: 11.sp,
                    color: colors.accentGold,
                  ),
                ),
              ],
            ),
          ),

          // Search Toggle Button
          IconButton(
            onPressed: () {
              HapticService.selectionClick();
              onToggleSearch();
            },
            icon: Icon(
              isSearchOpen ? Iconsax.close_circle : Iconsax.search_normal,
              size: 20.r,
              color: isSearchOpen ? colors.accentGold : colors.textSecondary,
            ),
            tooltip: 'بحث في الأحاديث',
          ),

          // Chapters Menu Button
          IconButton(
            onPressed: () {
              HapticService.selectionClick();
              onOpenChapters();
            },
            icon: Icon(
              Iconsax.sort,
              size: 20.r,
              color: colors.textSecondary,
            ),
            tooltip: 'فهرس الأبواب',
          ),
        ],
      ),
    );
  }
}

