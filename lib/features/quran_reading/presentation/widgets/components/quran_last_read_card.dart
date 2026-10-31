import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

/// "واصل من حيث توقفت" - Last read resume ribbon card.
/// Provides immediate one-tap continuation to the user's active reading marker.
class QuranLastReadCard extends StatelessWidget {
  final QuranBookmarkEntity? bookmark;
  final VoidCallback onResumeTap;

  const QuranLastReadCard({
    super.key,
    required this.bookmark,
    required this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    final surahName = bookmark?.surahName ?? 'سُورَةُ الرَّحْمَٰن';
    final ayahNumber = bookmark?.ayahNumber ?? 27;
    final pageNumber = bookmark?.pageNumber ?? 531;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        onTap: () {
          HapticService.selectionClick();
          onResumeTap();
        },
        padding: EdgeInsets.all(14.r),
        child: Row(
          children: [
            // Right Side: Bookmark Ribbon Icon & Reading Position Info (RTL Start)
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
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
                        size: 20.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وَاصِلْ مِنْ حَيْثُ تَوَقَّفْتَ',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.champagneGold,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          surahName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.pureChalk,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'الآية $ayahNumber • ص $pageNumber',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.mutedSilver,
                            fontSize: 10.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Left Side: Golden "واصل القراءة" Resume Button (RTL End)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticService.selectionClick();
                  onResumeTap();
                },
                borderRadius: BorderRadius.circular(12.r),
                splashColor: AppColors.emeraldGlow.withValues(alpha: 0.2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.obsidianCore,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'قِرَاءَة',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.obsidianCore,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
