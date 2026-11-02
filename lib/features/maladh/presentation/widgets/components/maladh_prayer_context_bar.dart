import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

/// Luxury Prayer Context & Countdown Bar (The First Half - Image 2).
/// Displays:
/// 1. Top context bar: Current prayer, central Hijri date tab, and next prayer.
/// 2. Hairline separator.
/// 3. Real-time dynamic countdown ticker updating every second.
/// Enclosed in a well-defined ("متحدد") luxury container with crisp borders.
class MaladhPrayerContextBar extends StatefulWidget {
  final String hijriDate;

  const MaladhPrayerContextBar({
    super.key,
    required this.hijriDate,
  });

  @override
  State<MaladhPrayerContextBar> createState() => _MaladhPrayerContextBarState();
}

class _MaladhPrayerContextBarState extends State<MaladhPrayerContextBar> {
  Timer? _timer;
  late PrayerScheduleInfo _scheduleInfo;

  @override
  void initState() {
    super.initState();
    _scheduleInfo = CairoPrayerTimesCalculator.calculate();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _scheduleInfo = CairoPrayerTimesCalculator.calculate();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Parse Hijri day and month safely
    final parts = widget.hijriDate.trim().split(' ');
    final hijriDay = parts.isNotEmpty ? parts[0] : '22';
    final hijriMonth = parts.length > 2
        ? '${parts[1]} ${parts[2]}'
        : (parts.length > 1 ? parts[1] : 'جُمَادَى الأُولَى');

    final countdownString = CairoPrayerTimesCalculator.formatCountdown(
      _scheduleInfo.remainingToNext,
      _scheduleInfo.nextPrayerName,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.6),
          width: 0.8.r,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Context Row: Current Prayer, Center Hijri Tab, Next Prayer
          _TopContextRow(
            hijriDay: hijriDay,
            hijriMonth: hijriMonth,
            currentPrayerText:
                '${_scheduleInfo.currentPrayerName} ${_scheduleInfo.currentPrayerTime}',
            nextPrayerText:
                '${_scheduleInfo.nextPrayerName} ${_scheduleInfo.nextPrayerTime}',
          ),

          // 2. Subtle Hairline Divider
          Container(
            height: 1.h,
            color: colors.borderHairline.withValues(alpha: 0.4),
          ),

          // 3. Live Countdown Ticker
          _LiveCountdownTicker(
            countdownText: countdownString,
          ),
        ],
      ),
    );
  }
}

class _TopContextRow extends StatelessWidget {
  final String hijriDay;
  final String hijriMonth;
  final String currentPrayerText;
  final String nextPrayerText;

  const _TopContextRow({
    required this.hijriDay,
    required this.hijriMonth,
    required this.currentPrayerText,
    required this.nextPrayerText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side: Current / Previous Prayer
          Expanded(
            child: Text(
              currentPrayerText,
              textAlign: TextAlign.start,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Center: Rounded Pill with Hijri Date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.6),
                width: 0.8.r,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hijriDay,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                Text(
                  hijriMonth,
                  style: GoogleFonts.cairo(
                    color: colors.accentGold,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),

          // Left Side: Next Approaching Prayer
          Expanded(
            child: Text(
              nextPrayerText,
              textAlign: TextAlign.end,
              style: GoogleFonts.cairo(
                color: colors.accentGold,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveCountdownTicker extends StatelessWidget {
  final String countdownText;

  const _LiveCountdownTicker({
    required this.countdownText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      alignment: Alignment.center,
      child: Text(
        countdownText,
        style: GoogleFonts.cairo(
          color: AppColors.champagneGold,
          fontSize: 15.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

