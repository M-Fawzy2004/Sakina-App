import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
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
    final colors = context.colors;

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
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: isSearchActive
                      ? colors.accentGold
                      : colors.cardSurface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isSearchActive
                        ? Iconsax.close_circle
                        : Iconsax.search_normal_1,
                    color: isSearchActive
                        ? colors.background
                        : colors.accentGold,
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
                color: colors.accentGold,
                size: 22.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'القُرْآنُ الكَرِيمُ',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: colors.accentGold,
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
