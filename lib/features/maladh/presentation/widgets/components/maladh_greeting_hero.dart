import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_date_prayer_row.dart';

/// Soul-soothing greeting hero card providing the spiritual greeting,
/// daily Athkar invocation, and the celestial date/prayer countdown.
/// Features generous typographic breathing room to prevent Tashkeel collision.
class MaladhGreetingHero extends StatelessWidget {
  final MaladhHeaderData data;

  const MaladhGreetingHero({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time-Aware Greeting Header Row with Generous Breathing Room
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Celestial Moon/Sun Badge
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.goldBorderStroke,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      FlutterIslamicIcons.crescentMoon,
                      color: AppColors.champagneGold,
                      size: 22.r,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Greeting Title & Invocation Subtitle (Comfortable line heights and gap)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.greetingTitle,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.champagneGold,
                          height: 1.45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        data.greetingSubtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mutedSilver,
                          fontSize: 12.5.sp,
                          height: 1.45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.verticalMd,

            // 2. Hairline Separator with Subtle Gold Fade
            Container(
              height: 1.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.goldBorderStroke,
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            AppSpacing.verticalMd,

            // 3. Status Row: Hijri Date + Next Prayer (No truncation)
            MaladhDatePrayerRow(
              hijriDate: data.hijriDate,
              nextPrayerName: data.nextPrayerName,
              nextPrayerRemaining: data.nextPrayerTimeRemaining,
            ),
          ],
        ),
      ),
    );
  }
}
