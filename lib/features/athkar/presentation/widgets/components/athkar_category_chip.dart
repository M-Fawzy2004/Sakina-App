import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';

/// Single interactive Category Card in the Athkar carousel.
class AthkarCategoryChip extends StatelessWidget {
  final AthkarCategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const AthkarCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  IconData _resolveIcon(String key) {
    switch (key) {
      case 'morning':
        return Iconsax.sun_1;
      case 'evening':
        return Iconsax.moon;
      case 'tasbih':
        return Iconsax.finger_cricle;
      case 'sleep':
        return Iconsax.star;
      case 'prayer':
        return FlutterIslamicIcons.prayingPerson;
      case 'waking':
        return Iconsax.sun_fog;
      case 'quran':
        return FlutterIslamicIcons.solidQuran2;
      case 'prophets':
        return Iconsax.crown;
      default:
        return Iconsax.finger_cricle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconData = _resolveIcon(category.iconKey);

    return GestureDetector(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.surfaceElevated
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? colors.accentGold : colors.borderHairline,
            width: isSelected ? 1.5.r : 1.r,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.15)
                    : colors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  iconData,
                  size: 16.r,
                  color: isSelected ? colors.accentGold : colors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.cairo(
                      fontSize: 12.5.sp,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? colors.accentGold : colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${category.count} ذِكْراً',
                    style: GoogleFonts.cairo(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
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
