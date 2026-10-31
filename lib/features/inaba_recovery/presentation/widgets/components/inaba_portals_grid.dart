import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_portal_card.dart';

class InabaPortalsGrid extends StatelessWidget {
  final VoidCallback onGoodDeedsTap;
  final VoidCallback onConfessionTap;
  final VoidCallback onCovenantTap;
  final VoidCallback onTreeTap;
  final VoidCallback onHopeDoseTap;

  const InabaPortalsGrid({
    super.key,
    required this.onGoodDeedsTap,
    required this.onConfessionTap,
    required this.onCovenantTap,
    required this.onTreeTap,
    required this.onHopeDoseTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding: EdgeInsets.only(bottom: 12.h, right: 4.w),
              child: Row(
                children: [
                  Icon(
                    FlutterIslamicIcons.solidCrescentMoon,
                    size: 14.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'أَبْوَابُ الرُّجُوعِ وَالإِنَابَةِ',
                    style: AppTextStyles.titleMediumOf(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // 1. الحسنات الماحية
            InabaPortalCard(
              title: 'الحَسَنَاتُ المَاحِيَةُ',
              subtitle: 'اختر عملاً صالحاً يبدل سيئة بحسنة ويقربك من الله',
              icon: Iconsax.heart_add,
              badgeText: 'أجر مضاعف',
              onTap: onGoodDeedsTap,
            ),
            SizedBox(height: 10.h),

            // 2. محراب البوح
            InabaPortalCard(
              title: 'مِحْرَابُ البَوْحِ',
              subtitle: 'مساحتك الآمنة للتأمل، المحاسبة، والفضفضة مع الله',
              icon: Iconsax.lock,
              badgeText: 'مساحة مشفرة',
              onTap: onConfessionTap,
            ),
            SizedBox(height: 10.h),

            // 3. تجديد العهد والتوبة
            InabaPortalCard(
              title: 'تَجْدِيدُ العَهْدِ وَالتَّوْبَةِ',
              subtitle: 'ابدأ من جديد.. فالله يقبل التوبة ويفرح بعودتك',
              icon: Iconsax.refresh_2,
              badgeText: 'خطوة بخطوة',
              onTap: onCovenantTap,
            ),
            SizedBox(height: 10.h),

            // 4. شجرة النور
            InabaPortalCard(
              title: 'شَجَرَةُ النُّورِ',
              subtitle: 'كل يوم تقترب من الله تنمو شجرة إيمانك وثباتك',
              icon: Iconsax.tree,
              badgeText: 'مستويات إيمانية',
              onTap: onTreeTap,
            ),
            SizedBox(height: 10.h),

            // 5. جرعة أمل يومية
            InabaPortalCard(
              title: 'جُرْعَةُ أَمَلٍ يَوْمِيَّةٍ',
              subtitle: 'حديث شريف أو قصة ملهمة لتقوية قلبك وبعث الرجاء',
              icon: Iconsax.gift,
              badgeText: 'يومي',
              onTap: onHopeDoseTap,
            ),
          ],
        ),
      ),
    );
  }
}
