import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Top Brand Sanctuary Header for Al-Mushaf:
/// Symmetrically balanced with a centered golden crescent emblem + «القُرْآنُ الكَرِيمُ»,
/// alongside an accessible search trigger.
class QuranMushafBrandHeader extends StatelessWidget {
  final VoidCallback onSearchToggle;
  final bool isSearchActive;

  const QuranMushafBrandHeader({
    super.key,
    required this.onSearchToggle,
    required this.isSearchActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Search Trigger Button (Left side)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticService.selectionClick();
                onSearchToggle();
              },
              borderRadius: BorderRadius.circular(12.r),
              splashColor: AppColors.goldGlowSoft,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: isSearchActive
                      ? AppColors.champagneGold
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: isSearchActive
                        ? HugeIcons.strokeRoundedCancel01
                        : HugeIcons.strokeRoundedSearch01,
                    color: isSearchActive
                        ? AppColors.obsidianCore
                        : AppColors.champagneGold,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ),

          // 2. Centered Crescent & Majestic Quran Calligraphy
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterIslamicIcons.solidCrescentMoon,
                color: AppColors.champagneGold,
                size: 22.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'القُرْآنُ الكَرِيمُ',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.champagneGold,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // 3. Symmetric Balance Spacer
          SizedBox(width: 40.r),
        ],
      ),
    );
  }
}
