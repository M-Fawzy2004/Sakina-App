import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Audio position scrubber with gold slider and elapsed/remaining duration badges.
class RecitationScrubberBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const RecitationScrubberBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatRemaining(Duration pos, Duration dur) {
    if (dur <= pos) return '0:00';
    final remaining = dur - pos;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '-$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final maxSeconds = duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;
    final currentSeconds = position.inSeconds.clamp(0, duration.inSeconds).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.h,
            activeTrackColor: AppColors.champagneGold,
            inactiveTrackColor: AppColors.surfaceElevated,
            thumbColor: AppColors.paleRadiance,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
            overlayColor: AppColors.goldGlowSoft,
          ),
          child: Slider(
            value: currentSeconds.clamp(0.0, maxSeconds),
            min: 0.0,
            max: maxSeconds,
            onChanged: (value) {
              onSeek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.mutedSilver,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                _formatRemaining(position, duration),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.mutedSilver,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

