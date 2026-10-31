import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// "واصل وردك القرآني" - Continue your Quranic portion card
/// featuring the sacred Surah Ar-Rahman, Sheikh Al-Minshawi reciter info,
/// and golden resume action button without overflow or unnecessary bookmark badge.
class MaladhContinueQuranCard extends StatelessWidget {
  final VoidCallback? onResumeTap;
  final VoidCallback? onCardTap;

  const MaladhContinueQuranCard({
    super.key,
    this.onResumeTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        onTap: onCardTap,
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Header Pill: "واصل وردك القرآني"
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: BoxDecoration(
                          color: colors.accentGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'واصل وردك القرآني',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.accentGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // 2. Surah Name in Imperial Calligraphy
            Text(
              'سُورَةُ الرَّحْمَٰن',
              textAlign: TextAlign.start,
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 27.sp,
                color: colors.accentGold,
                height: 1.3,
              ),
            ),

            SizedBox(height: 4.h),

            // 3. Ayah & Juz Subtitle
            Text(
              'الآية 27 • الجزء السابع والعشرون',
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                fontSize: 12.sp,
              ),
            ),

            AppSpacing.verticalMd,

            // 4. Inner Reciter & Resume Container (Overflow-Proof Responsive Layout)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  // Right Side: Reciter Avatar with Emerald Ring & Info (Takes available flex)
                  Expanded(
                    child: Row(
                      children: [
                        // Reciter Avatar with Emerald Ring
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.cardSurface,
                            border: Border.all(
                              color: colors.accentEmerald,
                              width: 1.5.r,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              FlutterIslamicIcons.quran2,
                              color: colors.accentGold,
                              size: 18.r,
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Reciter Name & Audio Description (Flex-safe)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'الشيخ محمد صِدِّيق المِنْشَاوِي',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 12.5.sp,
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.headphone,
                                    color: colors.accentGold,
                                    size: 13.r,
                                  ),
                                  SizedBox(width: 4.w),
                                  Flexible(
                                    child: Text(
                                      'تلاوة ترتيل خاشعة',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption.copyWith(
                                        color: colors.textSecondary,
                                        fontSize: 10.5.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Left Side: Golden "استئناف" Pill Action Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticService.selectionClick();
                        onResumeTap?.call();
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: colors.accentGold,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.play,
                              color: colors.background,
                              size: 16.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'استئناف',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.background,
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
          ],
        ),
      ),
    );
  }
}
