import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
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
    if (lastReadBookmark == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedBookmark02,
                color: AppColors.mutedSilver,
                size: 40.r,
              ),
              AppSpacing.verticalMd,
              Text(
                'لا توجد علامات محفوظة بعد',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.pureChalk,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'اضغط على أي آية أثناء القراءة لحفظ موضعك والرجوع إليه بسهولة',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.mutedSilver,
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
              color: AppColors.champagneGold,
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
            splashColor: AppColors.emeraldGlow.withValues(alpha: 0.2),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.emeraldGlow,
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
                      color: const Color(0x2210B981),
                      border: Border.all(
                        color: AppColors.emeraldGlow,
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedBookmark02,
                        color: AppColors.emeraldGlow,
                        size: 22.r,
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
                            color: AppColors.pureChalk,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'الآية ${bookmark.ayahNumber} • ص ${bookmark.pageNumber}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.mutedSilver,
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'مُتَابَعَة',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.obsidianCore,
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
