import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Animated 3D audio waveform visualization bar displaying alternating emerald and gold bars.
/// Smoothly undulates when [isPlaying] is active and rests gracefully when paused.
class MaladhAudioWaveform extends StatefulWidget {
  final bool isPlaying;

  const MaladhAudioWaveform({
    super.key,
    required this.isPlaying,
  });

  @override
  State<MaladhAudioWaveform> createState() => _MaladhAudioWaveformState();
}

class _MaladhAudioWaveformState extends State<MaladhAudioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  static const List<double> _baseHeights = [
    12, 18, 10, 24, 16, 28, 14, 26, 12, 32,
    20, 36, 24, 40, 22, 38, 18, 30, 14, 26,
    12, 28, 16, 22, 10, 18, 8, 14,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.isPlaying) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MaladhAudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.carbonSlate,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 1.r,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          final progress = _animationController.value;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_baseHeights.length, (index) {
              final baseH = _baseHeights[index];

              // Calculate dynamic undulating height using phase-shifted sine wave
              final phase = index * 0.28;
              final waveFactor = widget.isPlaying
                  ? (0.35 + 0.65 * (math.sin(progress * 2 * math.pi + phase)).abs())
                  : 0.45;

              final currentHeight = (baseH * waveFactor).clamp(6.0, 42.0).h;

              // Alternating rhythmic colors: emerald and champagne gold
              final isEmerald = index % 2 == 0;
              final barColor = isEmerald ? AppColors.emeraldGlow : AppColors.champagneGold;

              return Container(
                width: 4.w,
                height: currentHeight,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
