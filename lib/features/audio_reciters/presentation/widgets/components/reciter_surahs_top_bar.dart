import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Top sacred header bar for Reciter Surahs screen.
class ReciterSurahsTopBar extends StatelessWidget {
  final String reciterName;
  final VoidCallback onBackTap;

  const ReciterSurahsTopBar({
    super.key,
    required this.reciterName,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.6),
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.arrow_right_3,
                size: 18.r,
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'المصحف المرتل',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.accentGold,
                  ),
                ),
                Text(
                  reciterName,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.5),
                width: 0.8.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.headphone,
                  size: 13.r,
                  color: colors.accentGold,
                ),
                SizedBox(width: 4.w),
                Text(
                  'استماع مباشر',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
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

