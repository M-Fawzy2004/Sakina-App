import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/utils/surah_metadata_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Surah item card layout matching the user's design reference:
/// - Left: Bold English Surah ID numeral (1, 2, 3...)
/// - Beside ID: English Surah Name in Emerald Glow (Al-Fatihah, Al-Baqarah...)
/// - Subtitle: English translation/meaning + Revelation icon (Kaaba for Makki / Mosque for Madani)
/// - Right: Authentic Classical Arabic calligraphic title in Amiri font («سُورَةُ الفَاتِحَةِ»)
/// - Styled in luxury Obsidian & Champagne Gold tokens with 1px hairline border.
class QuranSurahMockupCard extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;

  const QuranSurahMockupCard({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final englishTranslation =
        SurahMetadataUtils.getEnglishTranslation(surah.id);
    final calligraphicTitle =
        SurahMetadataUtils.getCalligraphicSurahName(surah.id, surah.nameArabic);
    final isMakki = surah.revelationType.contains('مك') ||
        surah.revelationType.toLowerCase().contains('mak');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.5.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlowSoft,
          highlightColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.goldBorderStroke.withValues(alpha: 0.28),
                width: 1.r,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  // 1. Surah Index Numeral (1, 2, 3...)
                  SizedBox(
                    width: 26.w,
                    child: Text(
                      '${surah.id}',
                      textAlign: TextAlign.start,
                      style: AppTextStyles.surahCardIndex,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // 2. English Surah Name & Translation Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          surah.englishName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.surahCardEnglishTitle,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                englishTranslation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.surahCardEnglishSubtitle,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Icon(
                              isMakki
                                  ? FlutterIslamicIcons.solidKaaba
                                  : FlutterIslamicIcons.locationMosque,
                              size: 11.r,
                              color: AppColors.mutedSilver,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // 3. Classical Arabic Calligraphic Title (Amiri)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      calligraphicTitle,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.surahCardArabicTitle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
