import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';

/// Next prayer card displaying the upcoming prayer name, adhan time,
/// and live countdown ticker formatted to the second with spacious luxury proportions.
class PrayerNextCountdownCard extends StatefulWidget {
  final PrayerScheduleInfo scheduleInfo;

  const PrayerNextCountdownCard({
    super.key,
    required this.scheduleInfo,
  });

  @override
  State<PrayerNextCountdownCard> createState() => _PrayerNextCountdownCardState();
}

class _PrayerNextCountdownCardState extends State<PrayerNextCountdownCard> {
  Timer? _ticker;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.scheduleInfo.remainingToNext;
    _startTicker();
  }

  @override
  void didUpdateWidget(covariant PrayerNextCountdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scheduleInfo != widget.scheduleInfo) {
      _remaining = widget.scheduleInfo.remainingToNext;
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatTicker(Duration d) {
    final safe = d.isNegative ? Duration.zero : d;
    final h = safe.inHours;
    final m = (safe.inMinutes % 60).toString().padLeft(2, '0');
    final s = (safe.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  IconData _getPrayerIcon(int index) {
    switch (index) {
      case 0:
        return Icons.wb_twilight_rounded;
      case 1:
        return Icons.wb_sunny_rounded;
      case 2:
        return Iconsax.cloud_sunny;
      case 3:
        return Icons.wb_twilight_rounded;
      case 4:
      default:
        return Iconsax.moon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final nextName = widget.scheduleInfo.nextPrayerName;
    final nextTime = widget.scheduleInfo.nextPrayerTime;
    final icon = _getPrayerIcon(widget.scheduleInfo.nextPrayerIndex);
    const accentCyan = Color(0xFF38BDF8);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.7),
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Right Section (in RTL): "الصلاة القادمة" & Large Prayer Name
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الصَّلَاةُ القَادِمَة',
                  style: GoogleFonts.cairo(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: accentCyan,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  nextName,
                  style: GoogleFonts.cairo(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),

          // 2. Center Section (in RTL): Icon in circular disc
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  color: accentCyan.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentCyan.withValues(alpha: 0.35),
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 26.r,
                    color: accentCyan,
                  ),
                ),
              ),
            ),
          ),

          // 3. Left Section (in RTL): Prayer Adhan Time & Live Countdown Ticker
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nextTime,
                  style: GoogleFonts.cairo(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                    letterSpacing: 0.3,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTicker(_remaining),
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: accentCyan,
                    letterSpacing: 0.8,
                    height: 1.2,
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
