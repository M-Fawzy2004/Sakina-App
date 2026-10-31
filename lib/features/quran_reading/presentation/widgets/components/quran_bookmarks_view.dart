import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

/// Bookmarks and reading milestones catalog view.
class QuranBookmarksView extends StatelessWidget {
  final QuranBookmarkEntity? lastReadBookmark;
  final ValueChanged<QuranBookmarkEntity> onBookmarkTap;

  const QuranBookmarksView({
    super.key,
    required this.lastReadBookmark,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (lastReadBookmark == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.bookmark,
                color: colors.textSecondary,
                size: 40.r,
              ),
              AppSpacing.verticalMd,
              Text(
                'لا توجد علامات محفوظة بعد',
                style: AppTextStyles.titleMedium.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'اضغط على أي آية أثناء القراءة لحفظ موضعك والرجوع إليه بسهولة',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bookmark = lastReadBookmark!;

    return ListView(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 100.h),
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
          child: Text(
            'مَوْضِعُ القِرَاءَةِ الحَالِيّ',
            style: AppTextStyles.caption.copyWith(
              color: colors.accentGold,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ),

        // Bookmark Card
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticService.selectionClick();
              onBookmarkTap(bookmark);
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.accentEmerald,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.accentEmerald.withValues(alpha: 0.12),
                      border: Border.all(
                        color: colors.accentEmerald,
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.bookmark,
                        color: colors.accentEmerald,
                        size: 20.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookmark.surahName,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'الآية ${bookmark.ayahNumber} • ص ${bookmark.pageNumber}',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.textSecondary,
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors.accentGold,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'مُتَابَعَة',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.background,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
