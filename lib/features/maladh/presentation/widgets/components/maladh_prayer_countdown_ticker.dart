import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Reactive live countdown ticker actively updating remaining time
/// to the upcoming prayer (HH : MM : SS) every second.
class MaladhPrayerCountdownTicker extends StatefulWidget {
  final String prayerName;

  const MaladhPrayerCountdownTicker({
    super.key,
    this.prayerName = 'الْفَجْرُ',
  });

  @override
  State<MaladhPrayerCountdownTicker> createState() => _MaladhPrayerCountdownTickerState();
}

class _MaladhPrayerCountdownTickerState extends State<MaladhPrayerCountdownTicker> {
  Timer? _tickerTimer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _computeRemainingDuration();
    // 1-second live countdown ticker
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _computeRemainingDuration();
        });
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _computeRemainingDuration() {
    final now = DateTime.now();
    // Accurate Fajr time: 04:42 AM
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
    final hours = _remainingDuration.inHours;
    final minutes = _remainingDuration.inMinutes % 60;
    final seconds = _remainingDuration.inSeconds % 60;

    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    final countdownText = '$formattedHours : $formattedMinutes : $formattedSeconds';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emerald Glowing Status Indicator Dot
        Container(
          width: 7.r,
          height: 7.r,
          decoration: BoxDecoration(
            color: colors.accentEmerald,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        // Live Prayer Name & Ticking Countdown
        Text(
          '${widget.prayerName}: $countdownText',
          style: AppTextStyles.caption.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11.5.sp,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
