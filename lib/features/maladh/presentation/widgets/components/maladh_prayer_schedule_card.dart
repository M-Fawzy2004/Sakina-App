import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

/// "جدول الصلوات اليومية" - Comprehensive prayer times grid card (The Second Half).
/// Displays:
/// 1. The 5 daily Fard prayers with custom iconography and active prayer highlight.
/// 2. Supplementary celestial times (الشروق • منتصف الليل • الثلث الأخير).
class MaladhPrayerScheduleCard extends StatelessWidget {
  final String? hijriDate;
  final String? nextPrayerName;
  final VoidCallback? onPrayerTap;

  const MaladhPrayerScheduleCard({
    super.key,
    this.hijriDate,
    this.nextPrayerName,
    this.onPrayerTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduleInfo = CairoPrayerTimesCalculator.calculate();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.6),
            width: 0.8.r,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Five Daily Fard Prayers Row (الفجر، الظهر، العصر، المغرب، العشاء)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: _MainPrayersRow(
                activePrayerIndex: scheduleInfo.nextPrayerIndex,
              ),
            ),

            // 2. Hairline Divider
            Container(
              height: 1.h,
              color: colors.borderHairline.withValues(alpha: 0.35),
            ),

            // 3. Supplementary Sunnah Celestial Times (الشروق، منتصف الليل، الثلث الأخير)
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

/// Five Fard Prayers Grid Row with icons and times.
class _MainPrayersRow extends StatelessWidget {
  final int activePrayerIndex;

  const _MainPrayersRow({required this.activePrayerIndex});

  static const List<({String name, String time, IconData icon})> _prayers = [
    (
      name: 'الفجر',
      time: '4:41',
      icon: Icons.wb_twilight_rounded,
    ),
    (
      name: 'الظهر',
      time: '11:40',
      icon: Icons.wb_sunny_rounded,
    ),
    (
      name: 'العصر',
      time: '2:43',
      icon: Iconsax.cloud_sunny,
    ),
    (
      name: 'المغرب',
      time: '5:07',
      icon: Icons.wb_twilight_rounded,
    ),
    (
      name: 'العشاء',
      time: '6:26',
      icon: Iconsax.moon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_prayers.length, (index) {
        final p = _prayers[index];
        final isNext = index == activePrayerIndex;
        return Expanded(
          child: _SinglePrayerSlot(
            name: p.name,
            time: p.time,
            icon: p.icon,
            isNext: isNext,
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
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
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
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w700,
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
    (name: 'الشروق', time: '6:10'),
    (name: 'منتصف الليل', time: '10:55'),
    (name: 'الثلث الأخير', time: '12:50'),
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
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
        SizedBox(height: 3.h),
        Text(
          time,
          style: GoogleFonts.cairo(
            color: colors.accentGold,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
