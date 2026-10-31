import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_islamic_rosette_badge.dart';

/// Ornate Illuminated Islamic Manuscript Card matching the design screenshot:
/// - Golden arabesque frame with decorative top crest and bottom seal
/// - Classical Basmalah banner with golden floral divider
/// - Line-by-line illuminated verses with golden eight-pointed star badges
class QuranOrnateManuscriptCard extends StatelessWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final double fontSizeDelta;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;

  const QuranOrnateManuscriptCard({
    super.key,
    required this.surah,
    required this.verses,
    required this.fontSizeDelta,
    required this.selectedAyahNumber,
    required this.onAyahTap,
  });

  @override
  Widget build(BuildContext context) {
    final showBasmalah = surah.id != 9 && surah.id != 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.carbonSlate.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: AppColors.champagneGold.withValues(alpha: 0.75),
          width: 1.2.r,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.goldBorderStroke.withValues(alpha: 0.35),
            width: 0.8.r,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          children: [
            // 2. Classical Basmalah Banner with Floral Divider
            if (showBasmalah || surah.id == 1) ...[
              Center(
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.quranIlluminatedAyah.copyWith(
                    fontSize: 25.sp + fontSizeDelta,
                    color: AppColors.champagneGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.w,
                    height: 0.8.h,
                    color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.auto_awesome,
                    size: 11.r,
                    color: AppColors.champagneGold,
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 50.w,
                    height: 0.8.h,
                    color: AppColors.goldBorderStroke.withValues(alpha: 0.4),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
            ],

            // 3. Illuminated Line-by-Line Verses
            for (final ayah in verses) ...[
              _AyahRow(
                ayah: ayah,
                fontSizeDelta: fontSizeDelta,
                isSelected: selectedAyahNumber == ayah.numberInSurah,
                onTap: () => onAyahTap(ayah.numberInSurah),
              ),
              Divider(
                color: AppColors.goldBorderStroke.withValues(alpha: 0.2),
                height: 1.h,
                thickness: 0.6.r,
                indent: 10.w,
                endIndent: 10.w,
              ),
            ],

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final AyahEntity ayah;
  final double fontSizeDelta;
  final bool isSelected;
  final VoidCallback onTap;

  const _AyahRow({
    required this.ayah,
    required this.fontSizeDelta,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.emeraldGlow.withValues(alpha: 0.18)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        splashColor: AppColors.goldGlowSoft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ornate Golden 8-Pointed Star Badge («①»)
                QuranIslamicRosetteBadge(
                  number: ayah.numberInSurah,
                  isHighlighted: isSelected,
                ),

                // Illuminated Calligraphic Arabic Scripture
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ayah.text,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.quranIlluminatedAyah.copyWith(
                        fontSize: 22.sp + fontSizeDelta,
                        color: isSelected
                            ? AppColors.champagneGold
                            : AppColors.paleRadiance,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
