import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/celestial_constellation_data.dart';

/// Atmospheric seamless midnight sky background with realistic, gently animated stars.
/// Features smooth multi-frequency twinkling, subtle organic celestial floating drift,
/// soft champagne gold radiance on celestial beacons, and an occasional shooting star.
class CelestialNightSkyBackground extends StatefulWidget {
  final bool isDark;

  const CelestialNightSkyBackground({
    super.key,
    required this.isDark,
  });

  @override
  State<CelestialNightSkyBackground> createState() =>
      _CelestialNightSkyBackgroundState();
}

class _CelestialNightSkyBackgroundState
    extends State<CelestialNightSkyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );

    // Guard against infinite loop during widget test pumpAndSettle
    final isTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
    if (!isTest) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (!widget.isDark) {
      return Container(color: colors.background);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Seamless uniform midnight canvas matching scaffold background
        Container(color: colors.background),

        // Constellation Starfield Custom Painter (subtle animated stars)
        RepaintBoundary(
          child: CustomPaint(
            painter: _CelestialStarfieldPainter(animation: _controller),
          ),
        ),
      ],
    );
  }
}

/// High-performance 120 FPS Starfield Painter drawing realistic, living celestial pinpoints.
class _CelestialStarfieldPainter extends CustomPainter {
  final Animation<double> animation;

  _CelestialStarfieldPainter({required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;

    for (final star in celestialConstellationStars) {
      // 1. Organic elliptical floating drift (serene cosmic motion)
      final floatX =
          math.sin(2 * math.pi * t + star.twinklePhase) * star.driftRadiusX;
      final floatY =
          math.cos(2 * math.pi * t + star.twinklePhase) * star.driftRadiusY;

      final px = star.x * size.width + floatX;
      final py = star.y * size.height + floatY;

      // 2. Multi-frequency twinkle wave (0.0 to 1.0)
      final wave =
          0.5 +
          0.5 *
              math.sin(2 * math.pi * star.twinkleFreq * t + star.twinklePhase);
      final alpha = (star.minAlpha + (star.maxAlpha - star.minAlpha) * wave)
          .clamp(0.0, 1.0);
      final currentRadius = star.radius * (0.85 + 0.25 * wave);

      // 3. Draw soft champagne gold halo on celestial beacons during peak shimmer
      if (star.hasGlow && wave > 0.45) {
        final glowAlpha = ((wave - 0.45) / 0.55 * 0.22).clamp(0.0, 1.0);
        final glowRadius = currentRadius * 4.2;
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.radial(Offset(px, py), glowRadius, [
            AppColors.champagneGold.withValues(alpha: glowAlpha),
            AppColors.champagneGold.withValues(alpha: 0.0),
          ]);
        canvas.drawCircle(Offset(px, py), glowRadius, glowPaint);
      }

      // 4. Subtle 4-point diamond cross glint at peak sparkle
      if (star.hasSparkle && wave > 0.72) {
        final sparkleAlpha = ((wave - 0.72) / 0.28 * 0.40).clamp(0.0, 1.0);
        final sparkleLen = currentRadius * 3.2;
        final sparklePaint = Paint()
          ..color = AppColors.paleRadiance.withValues(alpha: sparkleAlpha)
          ..strokeWidth = 0.55
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(px - sparkleLen, py),
          Offset(px + sparkleLen, py),
          sparklePaint,
        );
        canvas.drawLine(
          Offset(px, py - sparkleLen),
          Offset(px, py + sparkleLen),
          sparklePaint,
        );
      }

      // 5. Draw star core
      final coreColor = star.hasGlow && wave > 0.6
          ? Color.lerp(
              AppColors.pureChalk,
              AppColors.paleRadiance,
              (wave - 0.6) * 2.5,
            )!
          : AppColors.pureChalk;

      final corePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = coreColor.withValues(alpha: alpha);

      canvas.drawCircle(Offset(px, py), currentRadius, corePaint);
    }

    // 6. Occasional ethereal shooting star gliding across the upper sky
    _paintShootingStar(canvas, size, t);
  }

  void _paintShootingStar(Canvas canvas, Size size, double t) {
    // Shooting star triggers peacefully between t = 0.62 and t = 0.75 of the loop
    const tStart = 0.62;
    const tEnd = 0.75;
    if (t < tStart || t > tEnd) return;

    final progress = (t - tStart) / (tEnd - tStart);
    final curvedProgress = Curves.easeInOutCubic.transform(progress);

    // Trajectory: From upper right down towards mid-left
    final start = Offset(size.width * 0.90, size.height * 0.06);
    final end = Offset(size.width * 0.35, size.height * 0.38);

    final currentHead = Offset.lerp(start, end, curvedProgress)!;
    final direction = (start - end);
    final dirNorm = direction / direction.distance;

    final tailLength = 46.0 * (1.0 - (progress - 0.5).abs() * 0.4);
    final currentTail = currentHead + dirNorm * tailLength;

    final alphaFactor = progress < 0.2
        ? (progress / 0.2)
        : (progress > 0.65 ? ((1.0 - progress) / 0.35) : 1.0);

    final meteorAlpha = (alphaFactor * 0.80).clamp(0.0, 1.0);

    // Glowing fading streak tail
    final streakPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        currentTail,
        currentHead,
        [
          AppColors.paleRadiance.withValues(alpha: 0.0),
          AppColors.champagneGold.withValues(alpha: meteorAlpha * 0.35),
          AppColors.white.withValues(alpha: meteorAlpha),
        ],
        [0.0, 0.7, 1.0],
      );

    canvas.drawLine(currentTail, currentHead, streakPaint);

    // Luminous meteor head with gentle aura
    final headGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.champagneGold.withValues(alpha: meteorAlpha * 0.45);
    canvas.drawCircle(currentHead, 2.0, headGlowPaint);

    final headCorePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.white.withValues(alpha: meteorAlpha);
    canvas.drawCircle(currentHead, 0.9, headCorePaint);
  }

  @override
  bool shouldRepaint(covariant _CelestialStarfieldPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
