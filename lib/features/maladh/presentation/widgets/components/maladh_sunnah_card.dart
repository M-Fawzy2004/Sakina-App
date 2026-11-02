import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// Flagship companion portal card for "كُتُبُ السُّنَّةِ النَّبَوِيَّةِ" (Kutub al-Tis'ah).
class MaladhSunnahCard extends StatelessWidget {
  final VoidCallback? onTap;

  const MaladhSunnahCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TactileGlassCard(
      onTap: () {
        HapticService.selectionClick();
        onTap?.call();
      },
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          // 1. Ornate Sunnah Medallion
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: colors.accentEmerald.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.accentEmerald.withValues(alpha: 0.35),
                width: 1.r,
              ),
            ),
            child: Center(
              child: Icon(
                FlutterIslamicIcons.solidQuran2,
                color: colors.accentEmerald,
                size: 20.r,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // 2. Title & Subtitle Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'كُتُبُ السُّنَّةِ النَّبَوِيَّةِ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: colors.accentGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: colors.accentGold.withValues(alpha: 0.35),
                          width: 0.8.r,
                        ),
                      ),
                      child: Text(
                        'كتب الأصول',
                        style: AppTextStyles.caption.copyWith(
                          color: colors.accentGold,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'الصِّحَاحُ وَالسُّنَنُ التِّسْعَةُ • 40,943 حَدِيثاً شَرِيفاً',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 10.5.sp,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // 3. Status Badge & Arrow
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.accentEmerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.accentEmerald.withValues(alpha: 0.35),
                    width: 1.r,
                  ),
                ),
                child: Text(
                  '9 كُتُبٍ',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.accentEmerald,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Iconsax.arrow_left_2,
                size: 16.r,
                color: colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

