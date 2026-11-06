import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

class SunnahBooksHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const SunnahBooksHeader({
    super.key,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticService.selectionClick();
              onBackTap();
            },
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.8),
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.arrow_right_3,
                  size: 20.r,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'كُتُبُ السُّنَّةِ النَّبَوِيَّةِ',
                      style: AppTextStyles.titleMediumOf(context).copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      FlutterIslamicIcons.quran2,
                      size: 15.r,
                      color: colors.accentGold,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'الصِّحَاحُ وَالسُّنَنُ وَالمَسَانِيدُ المُعْتَمَدَةُ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionOf(context).copyWith(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
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

