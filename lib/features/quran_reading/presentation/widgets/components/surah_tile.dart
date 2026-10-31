import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Luxury Surah catalog tile displaying number crest, Arabic name,
/// revelation location, verse count, and target page number.
class SurahTile extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;

  const SurahTile({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMeccan = surah.revelationType == 'مكية';

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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                // 1. Right Side: Ornamental Surah Number Crest (RTL Start)
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.goldBorderStroke,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.id}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // 2. Surah Titles & Metadata Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Surah Name (Arabic)
                      Text(
                        surah.nameArabic,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.pureChalk,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // English Name & Verses Count
                      Row(
                        children: [
                          Text(
                            surah.englishName,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.mutedSilver,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.mutedSilver,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            '${surah.versesCount} آيات',
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

                // 3. Left Side: Revelation Badge & Page Indicator (RTL End)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Revelation Type Tag (مكية / مدنية)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isMeccan
                            ? const Color(0x1AD4AF37)
                            : const Color(0x1A10B981),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isMeccan
                              ? AppColors.goldBorderStroke
                              : AppColors.emeraldGlow.withValues(alpha: 0.3),
                          width: 0.8.r,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMeccan
                                ? FlutterIslamicIcons.solidKaaba
                                : FlutterIslamicIcons.solidMosque,
                            color: isMeccan
                                ? AppColors.champagneGold
                                : AppColors.emeraldGlow,
                            size: 11.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            surah.revelationType,
                            style: AppTextStyles.caption.copyWith(
                              color: isMeccan
                                  ? AppColors.champagneGold
                                  : AppColors.emeraldGlow,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Target Mushaf Page Number
                    Text(
                      'ص ${surah.pageNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.mutedSilver,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

