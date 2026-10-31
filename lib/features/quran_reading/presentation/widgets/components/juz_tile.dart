import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';

/// Luxury Quranic Juz tile displaying Juz index, starting Surah, and page span.
class JuzTile extends StatelessWidget {
  final JuzEntity juz;
  final VoidCallback onTap;

  const JuzTile({
    super.key,
    required this.juz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlowSoft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.goldBorderStroke,
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                // 1. Right Side: Juz Number Badge
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.champagneGold,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${juz.id}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // 2. Juz Name & Start Verse Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        juz.nameArabic,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.pureChalk,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            FlutterIslamicIcons.quran,
                            color: AppColors.mutedSilver,
                            size: 12.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'يبدأ من: سورة ${juz.startSurahName} (الآية ${juz.startVerseNumber})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.mutedSilver,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Left Side: Page Range Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.goldBorderStroke,
                      width: 0.8.r,
                    ),
                  ),
                  child: Text(
                    'ص ${juz.startPageNumber} - ${juz.endPageNumber}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5.sp,
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

