import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

/// Sacred top brand header matching "سكينة 🌙" and "واجهة التلاوات".
class RecitersHeaderAppBar extends StatelessWidget {
  const RecitersHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'سكينة',
                    style: GoogleFonts.cairo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.champagneGold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '🌙',
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.frostedGlass,
              borderRadius: AppSpacing.radiusSm,
              border: Border.all(
                color: AppColors.goldBorderStroke,
                width: 1.r,
              ),
            ),
            child: Text(
              'واجهة التلاوات',
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.pureChalk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
