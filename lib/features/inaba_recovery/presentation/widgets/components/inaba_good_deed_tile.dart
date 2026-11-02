import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';

class InabaGoodDeedTile extends StatelessWidget {
  final GoodDeedEntity deed;
  final VoidCallback onTap;

  const InabaGoodDeedTile({
    super.key,
    required this.deed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: deed.isCompletedToday
                ? colors.surfaceElevated
                : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: deed.isCompletedToday
                  ? colors.accentGold
                  : colors.borderHairline,
              width: deed.isCompletedToday ? 1.5.r : 1.r,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: deed.isCompletedToday
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Icon(
                  _mapIconKey(deed.iconKey),
                  size: 20.r,
                  color: deed.isCompletedToday
                      ? colors.accentGold
                      : colors.textSecondary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            deed.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMediumOf(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '(${deed.completionCount}x)',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.accentGold,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      deed.rewardDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: deed.isCompletedToday
                      ? colors.accentGold
                      : colors.surfaceElevated,
                  border: Border.all(
                    color: deed.isCompletedToday
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.tick_circle,
                    size: 16.r,
                    color: deed.isCompletedToday
                        ? colors.background
                        : colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIconKey(String key) {
    switch (key) {
      case 'moon':
        return FlutterIslamicIcons.solidCrescentMoon;
      case 'tasbih':
        return FlutterIslamicIcons.tasbihHand;
      case 'book':
        return FlutterIslamicIcons.quran2;
      case 'people':
        return Iconsax.people;
      case 'hands':
        return Iconsax.lovely;
      case 'heart':
      default:
        return Iconsax.heart;
    }
  }
}

