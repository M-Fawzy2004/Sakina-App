import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class InabaEmergencyRescueSheet extends StatelessWidget {
  final VoidCallback onVictoryLogged;

  const InabaEmergencyRescueSheet({
    super.key,
    required this.onVictoryLogged,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onVictoryLogged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) => InabaEmergencyRescueSheet(
        onVictoryLogged: onVictoryLogged,
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
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet Handle Bar
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
              SizedBox(height: 18.h),

              // Shield Icon & Main Header
              Container(
                width: 58.r,
                height: 58.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceElevated,
                  border: Border.all(
                    color: colors.accentGold,
                    width: 1.5.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.shield_tick,
                    size: 28.r,
                    color: colors.accentGold,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                'مَلَاذُ اللُّجُوءِ وَالاسْتِعَاذَةِ',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'اثبت وتذكر.. لذة الطاعة تدوم، وشهوة المعصية تزول في ثانية',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: colors.accentGold,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),

              // Urgent Dhikr Card 1
              const _RescueItemCard(
                title: 'الاسْتِعَاذَةُ الفَوْرِيَّةُ',
                body:
                    '«أَعُوذُ بِاللَّهِ السَّمِيعِ العَلِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ، مِنْ هَمْزِهِ وَنَفْخِهِ وَنَفْثِهِ»',
                icon: FlutterIslamicIcons.prayingPerson,
              ),
              SizedBox(height: 10.h),

              // Urgent Dhikr Card 2
              const _RescueItemCard(
                title: 'سِلَاحُ التَّوْحِيدِ وَالحَوْقَلَةِ',
                body: '«لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ العَلِيِّ العَظِيمِ»',
                icon: FlutterIslamicIcons.tasbihHand,
              ),
              SizedBox(height: 10.h),

              // Quranic Anchor Card
              const _RescueItemCard(
                title: 'آيَةُ التَّثْبِيتِ وَالنَّجَاةِ',
                body:
                    '﴿ وَإِمَّا يَنزَغَنَّكَ مِنَ الشَّيْطَانِ نَزْغٌ فَاسْتَعِذْ بِاللَّهِ ۚ إِنَّهُ سَمِيعٌ عَلِيمٌ ﴾',
                icon: FlutterIslamicIcons.quran2,
              ),
              SizedBox(height: 22.h),

              // Victory Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentGold,
                    foregroundColor: colors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    onVictoryLogged();
                  },
                  icon: Icon(
                    Iconsax.verify,
                    size: 20.r,
                    color: colors.background,
                  ),
                  label: Text(
                    'الحمد لله.. ثبتّ وتجاوزت اللحظة بنصر',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.background,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RescueItemCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _RescueItemCard({
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.accentGold.withValues(alpha: 0.4),
                width: 1.r,
              ),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: colors.accentGold,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colors.accentGold,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
