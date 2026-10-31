import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Luminous audio waveform visualization with dynamic gold & emerald oscillating bars.
class RecitationAudioWaveform extends StatefulWidget {
  final bool isPlaying;

  const RecitationAudioWaveform({
    super.key,
    required this.isPlaying,
  });

  @override
  State<RecitationAudioWaveform> createState() => _RecitationAudioWaveformState();
}

class _RecitationAudioWaveformState extends State<RecitationAudioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RecitationAudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WaveformPainter(
              animationValue: _controller.value,
              isPlaying: widget.isPlaying,
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;

  // Base profile of normalized heights across 38 bars
  static const List<double> _baseHeights = [
    0.15, 0.22, 0.28, 0.35, 0.42, 0.50, 0.65, 0.80, 0.72, 0.58,
    0.85, 0.95, 0.78, 0.60, 0.90, 1.00, 0.88, 0.70, 0.82, 0.94,
    0.76, 0.55, 0.82, 0.68, 0.50, 0.72, 0.60, 0.45, 0.55, 0.38,
    0.48, 0.32, 0.25, 0.30, 0.20, 0.16, 0.12, 0.08,
  ];

  _WaveformPainter({
    required this.animationValue,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = _baseHeights.length;
    final totalSpacing = size.width * 0.4;
    final barWidth = (size.width - totalSpacing) / barCount;
    final gap = totalSpacing / (barCount - 1);
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);
      double normalized = _baseHeights[i];

      if (isPlaying) {
        // Dynamic oscillating fluctuation using sinusoidal phase offset
        final phase = animationValue * 2 * math.pi + (i * 0.35);
        final modulation = 0.75 + 0.25 * math.sin(phase);
        normalized = (normalized * modulation).clamp(0.12, 1.0);
      }

      final barHeight = normalized * (size.height - 4);
      final top = centerY - (barHeight / 2);
      final bottom = centerY + (barHeight / 2);

      final rect = Rect.fromPoints(
        Offset(x, top),
        Offset(x + barWidth, bottom),
      );

      // Gold to emerald gradient on each bar
      final paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.paleRadiance,
            AppColors.champagneGold,
            AppColors.emeraldGlow,
          ],
        ).createShader(rect);

      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying;
  }
}

