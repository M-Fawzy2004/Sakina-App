import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

class SettingsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 16.r,
                    color: colors.accentGold,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}

