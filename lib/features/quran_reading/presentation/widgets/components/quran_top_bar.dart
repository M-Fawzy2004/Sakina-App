import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Top sanctuary bar for Al-Mushaf displaying the brand emblem,
/// calligraphic title, narration subtitle, and search toggle.
class QuranTopBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onInfoTap;

  const QuranTopBar({
    super.key,
    this.onSearchTap,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side: Brand Emblem & Holy Quran Title (RTL Start)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Golden Crescent & Quran Icon Crest
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(
                    color: AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    FlutterIslamicIcons.solidQuran2,
                    color: AppColors.champagneGold,
                    size: 22.r,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'المُصْحَفُ الشَّرِيف',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.pureChalk,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'بِرِوَايَةِ حَفْصٍ عَنْ عَاصِم',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Left Side: Tactile Action Buttons (RTL End)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Shortcut Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticService.selectionClick();
                    onSearchTap?.call();
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  splashColor: AppColors.goldGlowSoft,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.goldBorderStroke,
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: AppColors.paleRadiance,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

