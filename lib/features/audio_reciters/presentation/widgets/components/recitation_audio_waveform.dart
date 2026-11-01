import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Luminous audio waveform visualization with dynamic gold & emerald oscillating bars.
/// Features high-fidelity organic multi-harmonic waves for live broadcast and studio recitations.
class RecitationAudioWaveform extends StatefulWidget {
  final bool isPlaying;
  final bool isLive;

  const RecitationAudioWaveform({
    super.key,
    required this.isPlaying,
    this.isLive = false,
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
      duration: Duration(milliseconds: widget.isLive ? 1200 : 1500),
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
      height: 60.h,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _WaveformPainter(
              animationValue: _controller.value,
              isPlaying: widget.isPlaying,
              isLive: widget.isLive,
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
  final bool isLive;

  // Base profile of normalized heights across 38 acoustic bars
  static const List<double> _baseHeights = [
    0.16, 0.24, 0.32, 0.42, 0.52, 0.65, 0.78, 0.88, 0.75, 0.62,
    0.86, 0.96, 0.82, 0.64, 0.92, 1.00, 0.90, 0.74, 0.85, 0.95,
    0.80, 0.60, 0.84, 0.70, 0.54, 0.74, 0.62, 0.48, 0.58, 0.42,
    0.50, 0.36, 0.28, 0.34, 0.24, 0.18, 0.14, 0.10,
  ];

  _WaveformPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.isLive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = _baseHeights.length;
    final totalSpacing = size.width * 0.42;
    final barWidth = (size.width - totalSpacing) / barCount;
    final gap = totalSpacing / (barCount - 1);
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);
      double normalized = _baseHeights[i];

      if (isPlaying) {
        // Multi-frequency harmonic sinusoidal modulation for natural organic motion
        final primaryWave = math.sin((animationValue * 2 * math.pi) + (i * 0.32));
        final secondaryWave = math.cos((animationValue * 4 * math.pi) + (i * 0.18));
        final modulation = isLive
            ? (0.68 + 0.24 * primaryWave + 0.10 * secondaryWave)
            : (0.72 + 0.28 * primaryWave);
        normalized = (normalized * modulation).clamp(0.12, 1.0);
      }

      final barHeight = normalized * (size.height - 4);
      final top = centerY - (barHeight / 2);
      final bottom = centerY + (barHeight / 2);

      final rect = Rect.fromPoints(
        Offset(x, top),
        Offset(x + barWidth, bottom),
      );

      // Gradient with radiant champagne gold & emerald sanctuary glow
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isLive
              ? const [
                  AppColors.paleRadiance,
                  AppColors.champagneGold,
                  AppColors.emeraldGlow,
                ]
              : const [
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
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.isLive != isLive;
  }
}
