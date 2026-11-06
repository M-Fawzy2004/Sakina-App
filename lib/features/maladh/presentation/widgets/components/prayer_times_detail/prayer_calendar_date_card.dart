import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_date_formatter.dart';

/// Celestial date and calendar banner displaying current day, month, moon crest,
/// and matching dual Hijri/Gregorian numeric pills.
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.6),
          width: 0.8.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Celestial Header Row: [Month Name] • [Moon Icon] • [Day Name]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gregorian Month Name
              Expanded(
                child: Text(
                  monthName,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.cairo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),

              // Crescent Moon Center Disc
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.3),
                    width: 0.8.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    FlutterIslamicIcons.solidCrescentMoon,
                    size: 18.r,
                    color: colors.accentGold,
                  ),
                ),
              ),

              // Day of the Week
              Expanded(
                child: Text(
                  dayName,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.cairo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. Dual Rounded Date Chips (Gregorian & Hijri)
          Row(
            children: [
              // Gregorian Numeric Pill
              Expanded(
                child: _DatePillChip(
                  label: gregorianNumeric,
                ),
              ),

              SizedBox(width: 12.w),

              // Hijri Numeric Pill
              Expanded(
                child: _DatePillChip(
                  label: hijri.formattedNumeric,
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
      height: 36.h,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 0.8.r,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

