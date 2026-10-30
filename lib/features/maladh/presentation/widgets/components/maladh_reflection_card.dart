import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// Serene daily Quranic reflection card displaying the verse of the day
/// with authenticated classical Uthmanic typography and sacred accents.
class MaladhReflectionCard extends StatelessWidget {
  final String verseText;
  final String surahSource;
  final VoidCallback? onBookmarkTap;

  const MaladhReflectionCard({
    super.key,
    required this.verseText,
    required this.surahSource,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Card Top Bar: Label & Sacred Bookmark Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FlutterIslamicIcons.solidQuran2,
                      color: AppColors.champagneGold,
                      size: 16.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'آيَةُ السَّكِينَةِ وَالتَّدَبُّرِ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.paleRadiance,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onBookmarkTap?.call();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedBookmark02,
                        color: AppColors.champagneGold,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSm,

            // 2. The Sacred Quranic Verse
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Text(
                verseText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.quranAyah.copyWith(
                  fontSize: 19.sp,
                  height: 2.1,
                  color: AppColors.pureChalk,
                ),
              ),
            ),

            AppSpacing.verticalXs,

            // 3. Surah & Ayah Citation Tag
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.carbonSlate,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Text(
                  surahSource,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.champagneGold,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
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
