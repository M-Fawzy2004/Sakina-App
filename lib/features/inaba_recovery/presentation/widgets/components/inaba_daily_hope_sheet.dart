import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';

class InabaDailyHopeSheet extends StatelessWidget {
  final DailyHopeDoseEntity? activeDose;
  final VoidCallback onNextDose;
  final VoidCallback onToggleSave;

  const InabaDailyHopeSheet({
    super.key,
    required this.activeDose,
    required this.onNextDose,
    required this.onToggleSave,
  });

  static Future<void> show(
    BuildContext context, {
    required DailyHopeDoseEntity? activeDose,
    required VoidCallback onNextDose,
    required VoidCallback onToggleSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) => InabaDailyHopeSheet(
        activeDose: activeDose,
        onNextDose: onNextDose,
        onToggleSave: onToggleSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 0.82.sh,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(color: colors.borderHairline, width: 1.r),
        ),
        child: Column(
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderHairline,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Icon(
                    Iconsax.gift,
                    size: 22.r,
                    color: colors.accentGold,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جُرْعَةُ أَمَلٍ يَوْمِيَّةٍ',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'حديث شريف أو قصة ملهمة لتقوية قلبك وبعث الرجاء',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Manuscript Card
            if (activeDose != null)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 22.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.5),
                      width: 1.2.r,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterIslamicIcons.quran2,
                          size: 30.r,
                          color: colors.accentGold,
                        ),
                        SizedBox(height: 16.h),

                        // Quotation
                        Text(
                          activeDose!.quotation,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Source
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.cardSurface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.borderHairline,
                              width: 1.r,
                            ),
                          ),
                          child: Text(
                            activeDose!.source,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.accentGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),

                        // Explanation
                        Text(
                          activeDose!.explanation,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 13.sp,
                            height: 1.6,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 18.h),

            // Bottom Actions: Next, Save, Share
            Row(
              children: [
                // Next Card Button
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentGold,
                      foregroundColor: colors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onNextDose();
                    },
                    icon: Icon(
                      Iconsax.refresh,
                      size: 18.r,
                      color: colors.background,
                    ),
                    label: Text(
                      'بِطَاقَةٌ تَالِيَةٌ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.background,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Save Button
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: activeDose?.isSaved == true
                          ? colors.accentGold
                          : colors.textSecondary,
                      side: BorderSide(
                        color: activeDose?.isSaved == true
                            ? colors.accentGold
                            : colors.borderHairline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      onToggleSave();
                    },
                    icon: Icon(
                      activeDose?.isSaved == true
                          ? Iconsax.archive_tick
                          : Iconsax.archive_1,
                      size: 18.r,
                      color: activeDose?.isSaved == true
                          ? colors.accentGold
                          : colors.textSecondary,
                    ),
                    label: Text(
                      activeDose?.isSaved == true ? 'محفوظة' : 'حِفْظٌ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
