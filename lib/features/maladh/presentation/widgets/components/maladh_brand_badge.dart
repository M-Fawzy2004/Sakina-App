import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Luxury brand identity mark displaying the golden Sakina crescent emblem,
/// calligraphic title, and sacred spiritual motto without blurry shadows.
class MaladhBrandBadge extends StatelessWidget {
  const MaladhBrandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Royal Sacred Crescent Emblem in Clean Frosted Glass Medallion
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: colors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              FlutterIslamicIcons.solidCrescentMoon,
              color: colors.accentGold,
              size: 20.r,
            ),
          ),
        ),

        SizedBox(width: 10.w),

        // 2. Imperial Calligraphic Brand Title & Motto
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سَكِينَة',
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 22.sp,
                height: 1.2,
                color: colors.accentGold,
              ),
            ),
            Text(
              'مَلَاذُ الرُّوحِ وَالقُرْآنِ',
              style: AppTextStyles.caption.copyWith(
                color: colors.textSecondary,
                fontSize: 10.sp,
                height: 1.1,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
