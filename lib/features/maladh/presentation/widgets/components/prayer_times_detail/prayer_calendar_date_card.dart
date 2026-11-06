import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_date_formatter.dart';

/// Celestial date and calendar banner displaying current day, month, moon crest,
/// and matching dual Hijri/Gregorian numeric pills with generous, luxury proportions.
class PrayerCalendarDateCard extends StatelessWidget {
  final DateTime now;

  const PrayerCalendarDateCard({
    super.key,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dayName = PrayerDateFormatter.getDayNameArabic(now);
    final monthName = PrayerDateFormatter.getGregorianMonthNameArabic(now);
    final gregorianNumeric = PrayerDateFormatter.formatGregorianNumeric(now);
    final hijri = PrayerDateFormatter.computeHijri(now);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 1.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Celestial Header Row in RTL: [Day Name (Right)] • [Moon Disc (Center)] • [Month Name (Left)]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day of the Week (Right in RTL)
              Expanded(
                child: Text(
                  dayName,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    height: 1.15,
                  ),
                ),
              ),

              // Crescent Moon Center Disc
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.35),
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    FlutterIslamicIcons.solidCrescentMoon,
                    size: 24.r,
                    color: colors.accentGold,
                  ),
                ),
              ),

              // Gregorian Month Name (Left in RTL)
              Expanded(
                child: Text(
                  monthName,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.cairo(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 2. Dual Rounded Date Chips in RTL: [Hijri (Right)] • [Gregorian (Left)]
          Row(
            children: [
              // Hijri Numeric Pill (Right in RTL)
              Expanded(
                child: _DatePillChip(
                  label: hijri.formattedNumeric,
                ),
              ),

              SizedBox(width: 14.w),

              // Gregorian Numeric Pill (Left in RTL)
              Expanded(
                child: _DatePillChip(
                  label: gregorianNumeric,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatePillChip extends StatelessWidget {
  final String label;

  const _DatePillChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.8),
          width: 1.r,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
