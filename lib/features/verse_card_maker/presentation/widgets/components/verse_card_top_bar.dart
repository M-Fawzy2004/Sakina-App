import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Top header bar for the Verse Card Studio matching the unified Athkar aesthetic:
/// circular touch targets, dual typography sacred branding, and a random ayah picker.
class VerseCardTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onRandomAyah;

  const VerseCardTopBar({
    super.key,
    required this.onBack,
    this.onRandomAyah,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Unified Circular Back Action (RTL: right side)
          GestureDetector(
            onTap: () {
              HapticService.selectionClick();
              onBack();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
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
                  Iconsax.arrow_right_3,
                  size: 18.r,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),

          // Central Sacred Typography Header
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'صَانِعُ بِطَاقَاتِ الآيَاتِ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.accentGold,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'تصميم 4K ومقاطع ريلز مع التلاوة',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Side Balancing Action: Random Verse Picker
          GestureDetector(
            onTap: () {
              HapticService.selectionClick();
              onRandomAyah?.call();
            },
            child: Container(
              width: 40.r,
              height: 40.r,
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
                  Iconsax.magic_star,
                  size: 18.r,
                  color: colors.accentGold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
