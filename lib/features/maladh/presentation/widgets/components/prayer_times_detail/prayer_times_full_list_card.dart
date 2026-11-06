import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

/// Detailed 6-slot prayer times card displaying Fajr, Sunrise, Dhuhr, Asr,
/// Maghrib, and Isha with calculated Iqamah times and spacious, luxury proportions.
class PrayerTimesFullListCard extends StatelessWidget {
  final PrayerScheduleInfo scheduleInfo;
  final DateTime now;

  const PrayerTimesFullListCard({
    super.key,
    required this.scheduleInfo,
    required this.now,
  });

  String _format12WithPeriod(DateTime? dt) {
    if (dt == null) return '--:--';
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'م' : 'ص';
    return '$hour12:$m $period';
  }

  String _format12Hour(DateTime dt) {
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$hour12:$m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFriday = now.weekday == DateTime.friday;

    final fajr = scheduleInfo.fajrTime ?? now;
    final sunrise = scheduleInfo.sunriseTime ?? now;
    final dhuhr = scheduleInfo.dhuhrTime ?? now;
    final asr = scheduleInfo.asrTime ?? now;
    final maghrib = scheduleInfo.maghribTime ?? now;
    final isha = scheduleInfo.ishaTime ?? now;

    final fajrIqamah = _format12Hour(fajr.add(const Duration(minutes: 25)));
    final sunriseIshraq = _format12Hour(sunrise.add(const Duration(minutes: 20)));
    final dhuhrSub = isFriday
        ? 'الإقامة بعد خطبة الجمعة'
        : 'الإقامة : ${_format12Hour(dhuhr.add(const Duration(minutes: 20)))}';
    final asrIqamah = _format12Hour(asr.add(const Duration(minutes: 20)));
    final maghribIqamah = _format12Hour(maghrib.add(const Duration(minutes: 10)));
    final ishaIqamah = _format12Hour(isha.add(const Duration(minutes: 15)));

    final rows = [
      _PrayerRowData(
        name: 'الفجر',
        timeFormatted: _format12WithPeriod(fajr),
        subLabel: 'الإقامة : $fajrIqamah',
        icon: Icons.wb_twilight_rounded,
        isNext: scheduleInfo.nextPrayerIndex == 0,
      ),
      _PrayerRowData(
        name: 'الشروق',
        timeFormatted: _format12WithPeriod(sunrise),
        subLabel: 'بداية الإشراق : $sunriseIshraq',
        icon: Icons.wb_sunny_outlined,
        isNext: false,
      ),
      _PrayerRowData(
        name: 'الظهر',
        timeFormatted: _format12WithPeriod(dhuhr),
        subLabel: dhuhrSub,
        icon: Icons.wb_sunny_rounded,
        isNext: scheduleInfo.nextPrayerIndex == 1,
      ),
      _PrayerRowData(
        name: 'العصر',
        timeFormatted: _format12WithPeriod(asr),
        subLabel: 'الإقامة : $asrIqamah',
        icon: Iconsax.cloud_sunny,
        isNext: scheduleInfo.nextPrayerIndex == 2,
      ),
      _PrayerRowData(
        name: 'المغرب',
        timeFormatted: _format12WithPeriod(maghrib),
        subLabel: 'الإقامة : $maghribIqamah',
        icon: Icons.wb_twilight_rounded,
        isNext: scheduleInfo.nextPrayerIndex == 3,
      ),
      _PrayerRowData(
        name: 'العشاء',
        timeFormatted: _format12WithPeriod(isha),
        subLabel: 'الإقامة : $ishaIqamah',
        icon: Iconsax.moon,
        isNext: scheduleInfo.nextPrayerIndex == 4,
      ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 1.r,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows.length, (index) {
          final item = rows[index];
          final isLast = index == rows.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PrayerItemRow(data: item),
              if (!isLast)
                Container(
                  height: 1.h,
                  color: colors.borderHairline.withValues(alpha: 0.4),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _PrayerRowData {
  final String name;
  final String timeFormatted;
  final String subLabel;
  final IconData icon;
  final bool isNext;

  const _PrayerRowData({
    required this.name,
    required this.timeFormatted,
    required this.subLabel,
    required this.icon,
    required this.isNext,
  });
}

class _PrayerItemRow extends StatelessWidget {
  final _PrayerRowData data;

  const _PrayerItemRow({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final highlightBg = data.isNext
        ? colors.accentGold.withValues(alpha: 0.12)
        : Colors.transparent;
    final primaryColor = data.isNext ? colors.accentGold : colors.textPrimary;
    final secondaryColor = colors.textSecondary;

    return Container(
      color: highlightBg,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 17.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Right side (in RTL): Prayer Name
          Expanded(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                data.name,
                style: GoogleFonts.almarai(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                  height: 1.2,
                ),
              ),
            ),
          ),

          // 2. Center (in RTL): Icon in circular disc
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: data.isNext
                      ? colors.accentGold.withValues(alpha: 0.18)
                      : colors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: data.isNext
                        ? colors.accentGold.withValues(alpha: 0.4)
                        : colors.borderHairline.withValues(alpha: 0.7),
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    data.icon,
                    size: 22.r,
                    color: data.isNext ? colors.accentGold : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // 3. Left side (in RTL): Time in 12-hour format with ص/م and Iqamah
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.timeFormatted,
                  style: GoogleFonts.almarai(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    letterSpacing: 0.3,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.subLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.almarai(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: secondaryColor,
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
