import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// "مواقيت الصلاة والجدول اليومي" - Comprehensive prayer times & celestial countdown card
/// matching the luxury reference design with zero drop shadows:
/// 1. Top context bar with central Hijri date tab and bounding prayers (العشاء 06:26 • 21 جمادى الأولى • الفجر 04:42).
/// 2. Live countdown ticker (الفجر بعد 08:11:07) updating every second.
/// 3. The 5 daily Fard prayers with custom iconography and active prayer highlight.
/// 4. Supplementary Islamic times (الشروق • منتصف الليل • الثلث الأخير).
class MaladhPrayerScheduleCard extends StatefulWidget {
  final String hijriDate;
  final String nextPrayerName;
  final VoidCallback? onPrayerTap;

  const MaladhPrayerScheduleCard({
    super.key,
    required this.hijriDate,
    required this.nextPrayerName,
    this.onPrayerTap,
  });

  @override
  State<MaladhPrayerScheduleCard> createState() =>
      _MaladhPrayerScheduleCardState();
}

class _MaladhPrayerScheduleCardState extends State<MaladhPrayerScheduleCard> {
  Timer? _countdownTimer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _computeRemainingDuration();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _computeRemainingDuration();
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _computeRemainingDuration() {
    final now = DateTime.now();
    // Accurate calculation for next prayer (Fajr 04:42 AM default target)
    final targetToday = DateTime(now.year, now.month, now.day, 4, 42, 0);
    final targetTime = now.isBefore(targetToday)
        ? targetToday
        : targetToday.add(const Duration(days: 1));

    final diff = targetTime.difference(now);
    _remainingDuration = diff.isNegative ? Duration.zero : diff;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Parse Hijri day and month
    final parts = widget.hijriDate.trim().split(' ');
    final hijriDay = parts.isNotEmpty ? parts[0] : '21';
    final hijriMonth = parts.length > 2
        ? '${parts[1]} ${parts[2]}'
        : (parts.length > 1 ? parts[1] : 'جمادى الأولى');

    final hours = _remainingDuration.inHours.toString().padLeft(2, '0');
    final minutes =
        (_remainingDuration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds =
        (_remainingDuration.inSeconds % 60).toString().padLeft(2, '0');
    final countdownString = '${widget.nextPrayerName} بعد $hours:$minutes:$seconds';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Context Bar: Hijri Center Tab + Current/Next Prayers
            _PrayerHeaderContextBar(
              hijriDay: hijriDay,
              hijriMonth: hijriMonth,
              currentPrayerText: 'العشاء 06:26',
              nextPrayerText: 'الفجر 04:42',
            ),

            // 2. Live Countdown Ticker
            _PrayerLiveCountdownTicker(
              countdownText: countdownString,
            ),

            // 3. Hairline Divider
            Container(
              height: 1.h,
              color: colors.borderHairline.withValues(alpha: 0.5),
            ),

            // 4. Five Daily Prayers Row (الفجر، الظهر، العصر، المغرب، العشاء)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: const _MainPrayersRow(),
            ),

            // 5. Hairline Divider
            Container(
              height: 1.h,
              color: colors.borderHairline.withValues(alpha: 0.35),
            ),

            // 6. Supplementary Sunnah Celestial Times (الشروق، منتصف الليل، الثلث الأخير)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: const _SupplementaryTimesRow(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top Context Bar displaying the central rounded Hijri tab with bounding prayer times.
class _PrayerHeaderContextBar extends StatelessWidget {
  final String hijriDay;
  final String hijriMonth;
  final String currentPrayerText;
  final String nextPrayerText;

  const _PrayerHeaderContextBar({
    required this.hijriDay,
    required this.hijriMonth,
    required this.currentPrayerText,
    required this.nextPrayerText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      color: colors.surfaceElevated,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Right Side (RTL Start): Current Prayer Time
          Flexible(
            child: Text(
              currentPrayerText,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Center: The Distinctive Rounded Hijri Tab
          _HijriCenterTab(
            day: hijriDay,
            month: hijriMonth,
          ),

          // Left Side (RTL End): Next Prayer Time
          Flexible(
            child: Text(
              nextPrayerText,
              textAlign: TextAlign.end,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
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

/// Central curved Hijri date tab matching reference design.
class _HijriCenterTab extends StatelessWidget {
  final String day;
  final String month;

  const _HijriCenterTab({
    required this.day,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            Text(
              month,
              style: GoogleFonts.cairo(
                color: colors.accentGold,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Prominent golden countdown ticker matching reference design.
class _PrayerLiveCountdownTicker extends StatelessWidget {
  final String countdownText;

  const _PrayerLiveCountdownTicker({
    required this.countdownText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      alignment: Alignment.center,
      child: Text(
        countdownText,
        style: GoogleFonts.cairo(
          color: AppColors.champagneGold,
          fontSize: 17.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Five Fard Prayers Grid Row with icons and times.
class _MainPrayersRow extends StatelessWidget {
  const _MainPrayersRow();

  static const List<({String name, String time, IconData icon, bool isNext})>
      _prayers = [
    (
      name: 'الفجر',
      time: '4:42',
      icon: Icons.wb_twilight_rounded,
      isNext: true,
    ),
    (
      name: 'الظهر',
      time: '11:45',
      icon: Icons.wb_sunny_rounded,
      isNext: false,
    ),
    (
      name: 'العصر',
      time: '2:55',
      icon: Iconsax.cloud_sunny,
      isNext: false,
    ),
    (
      name: 'المغرب',
      time: '5:07',
      icon: Icons.wb_twilight_rounded,
      isNext: false,
    ),
    (
      name: 'العشاء',
      time: '6:26',
      icon: Iconsax.moon,
      isNext: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_prayers.length, (index) {
        final p = _prayers[index];
        return Expanded(
          child: _SinglePrayerSlot(
            name: p.name,
            time: p.time,
            icon: p.icon,
            isNext: p.isNext,
          ),
        );
      }),
    );
  }
}

/// Individual column representing a single prayer time slot.
class _SinglePrayerSlot extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;

  const _SinglePrayerSlot({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryColor = isNext ? AppColors.champagneGold : Colors.white;
    final subtitleColor =
        isNext ? AppColors.champagneGold : colors.textSecondary;

    return InkWell(
      onTap: () => HapticService.selectionClick(),
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: GoogleFonts.cairo(
                color: subtitleColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 5.h),
            Icon(
              icon,
              size: 20.r,
              color: primaryColor,
            ),
            SizedBox(height: 5.h),
            Text(
              time,
              style: GoogleFonts.cairo(
                color: primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Supplementary Celestial Times Row (الشروق • منتصف الليل • الثلث الأخير).
class _SupplementaryTimesRow extends StatelessWidget {
  const _SupplementaryTimesRow();

  static const List<({String name, String time})> _times = [
    (name: 'الشروق', time: '6:08'),
    (name: 'منتصف الليل', time: '10:55'),
    (name: 'الثلث الأخير', time: '1:15'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _SupplementaryTimeItem(
            name: _times[0].name,
            time: _times[0].time,
          ),
        ),
        Container(
          width: 1.w,
          height: 22.h,
          color: colors.borderHairline.withValues(alpha: 0.35),
        ),
        Expanded(
          child: _SupplementaryTimeItem(
            name: _times[1].name,
            time: _times[1].time,
          ),
        ),
        Container(
          width: 1.w,
          height: 22.h,
          color: colors.borderHairline.withValues(alpha: 0.35),
        ),
        Expanded(
          child: _SupplementaryTimeItem(
            name: _times[2].name,
            time: _times[2].time,
          ),
        ),
      ],
    );
  }
}

/// Single item for supplementary times.
class _SupplementaryTimeItem extends StatelessWidget {
  final String name;
  final String time;

  const _SupplementaryTimeItem({
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: GoogleFonts.cairo(
            color: colors.textSecondary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          time,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
