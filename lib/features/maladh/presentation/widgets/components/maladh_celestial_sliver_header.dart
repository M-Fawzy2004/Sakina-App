import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_context_bar.dart';

/// Large collapsible celestial Sliver header for Al-Maladh (The Sanctuary).
/// Recreates the serene midnight sky aesthetic with tiny realistic starry pinpoints,
/// pure Quranic Ayah without brackets, zero elevation tint, zero drop shadows,
/// and smooth starlight fade-out during scroll to prevent any clipping.
class MaladhCelestialSliverHeader extends StatefulWidget {
  final MaladhHeaderData data;
  final VoidCallback? onPlayVerseTap;

  const MaladhCelestialSliverHeader({
    super.key,
    required this.data,
    this.onPlayVerseTap,
  });

  @override
  State<MaladhCelestialSliverHeader> createState() =>
      _MaladhCelestialSliverHeaderState();
}

class _MaladhCelestialSliverHeaderState
    extends State<MaladhCelestialSliverHeader> {
  AudioPlayerHandler? _audioHandler;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudioHandler();
  }

  void _initAudioHandler() {
    try {
      _audioHandler = sl<AudioPlayerHandler>();
      _playerStateSubscription = _audioHandler?.playerStateStream.listen((
        state,
      ) {
        if (!mounted) return;
        final playing =
            state.playing && state.processingState != ProcessingState.completed;
        if (_isPlaying != playing) {
          setState(() {
            _isPlaying = playing;
          });
        }
      });
    } catch (_) {
      // Audio handler fallback
    }
  }

  Future<void> _toggleRecitation() async {
    HapticService.selectionClick();
    widget.onPlayVerseTap?.call();

    if (_audioHandler == null) return;

    try {
      if (_isPlaying) {
        await _audioHandler!.pause();
      } else {
        await _audioHandler!.setAudioUrl(widget.data.dailyVerseAudioUrl);
        await _audioHandler!.play();
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final minHeight = 54.h + 88.h + topPadding;
    final maxHeight = 225.h + 88.h + topPadding;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MaladhCelestialHeaderDelegate(
        data: widget.data,
        isPlaying: _isPlaying,
        minHeight: minHeight,
        maxHeight: maxHeight,
        topPadding: topPadding,
        onToggleRecitation: _toggleRecitation,
      ),
    );
  }
}

class _MaladhCelestialHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MaladhHeaderData data;
  final bool isPlaying;
  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final VoidCallback onToggleRecitation;

  const _MaladhCelestialHeaderDelegate({
    required this.data,
    required this.isPlaying,
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
    required this.onToggleRecitation,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = context.colors;

    // Smooth early fade: Ayah fades out completely over first 60px of scroll
    final verseOpacity = (1.0 - (shrinkOffset / 60.h)).clamp(0.0, 1.0);
    final starOpacity = (1.0 - (shrinkOffset / 100.h)).clamp(0.0, 1.0);
    final subtitleOpacity = (1.0 - (shrinkOffset / 35.h)).clamp(0.0, 1.0);

    final maxScrollOffset = maxHeight - minHeight;
    final contextBarOffset = (maxScrollOffset - shrinkOffset).clamp(
      0.0,
      maxScrollOffset,
    );

    return Container(
      // Keep exact matching canvas background with zero elevation tint
      color: colors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Deep Seamless Midnight Night Sky with realistic tiny animated stars
          Opacity(
            opacity: starOpacity,
            child: _CelestialNightSkyBackground(
              key: const ValueKey('celestial_night_sky'),
              isDark: colors.isDark,
            ),
          ),

          // 2. Center Prominent Quranic Ayah (Fades gracefully as soon as scroll begins)
          if (verseOpacity > 0.01)
            Positioned(
              top: topPadding + 54.h,
              left: 16.w,
              right: 16.w,
              height: 155.h,
              child: Opacity(
                opacity: verseOpacity,
                child: Transform.translate(
                  offset: Offset(0, -18.h * (1.0 - verseOpacity)),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _CelestialAyahCard(
                        verseText: data.dailyVerseText,
                        surahSource: data.dailyVerseSurah,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 3. Pinned Top Bar (Brand on Right RTL, Frosted Play Button on Left RTL)
          Positioned(
            top: topPadding + 4.h,
            left: 16.w,
            right: 16.w,
            height: 48.h,
            child: _CelestialTopBar(
              subtitleOpacity: subtitleOpacity,
              isPlaying: isPlaying,
              onToggleRecitation: onToggleRecitation,
            ),
          ),

          // 4. Luxury Prayer Context & Countdown Bar (The First Half - Image 2)
          // Sits attached at the bottom of the expanded header ("لازق في آخر الـ sliver"),
          // and smoothly slides up to lock right beneath the top bar ("يلزق في الـ header").
          Positioned(
            top: topPadding + 54.h + contextBarOffset,
            left: 0,
            right: 0,
            child: MaladhPrayerContextBar(hijriDate: data.hijriDate),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _MaladhCelestialHeaderDelegate oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.topPadding != topPadding;
  }
}

/// Atmospheric seamless midnight sky background with realistic, gently animated stars.
/// Features smooth multi-frequency twinkling, subtle organic celestial floating drift,
/// soft champagne gold radiance on celestial beacons, and an occasional shooting star.
class _CelestialNightSkyBackground extends StatefulWidget {
  final bool isDark;

  const _CelestialNightSkyBackground({super.key, required this.isDark});

  @override
  State<_CelestialNightSkyBackground> createState() =>
      _CelestialNightSkyBackgroundState();
}

class _CelestialNightSkyBackgroundState
    extends State<_CelestialNightSkyBackground>
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
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
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

/// Star particle definition for harmonic celestial animation.
class _StarParticle {
  final double x; // Normalized 0..1 horizontal position
  final double y; // Normalized 0..1 vertical position
  final double radius; // Base star core radius in pixels
  final double minAlpha; // Minimum dimmed opacity
  final double maxAlpha; // Peak brightness opacity
  final double twinkleFreq; // Twinkle frequency multiplier
  final double twinklePhase; // Phase offset in radians
  final double driftRadiusX; // Subtle horizontal floating drift amplitude in px
  final double driftRadiusY; // Subtle vertical floating drift amplitude in px
  final bool hasGlow; // Soft champagne gold radial aura
  final bool hasSparkle; // Subtle 4-point diamond cross glint at peak

  const _StarParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.minAlpha,
    required this.maxAlpha,
    required this.twinkleFreq,
    required this.twinklePhase,
    this.driftRadiusX = 4.0,
    this.driftRadiusY = 2.5,
    this.hasGlow = false,
    this.hasSparkle = false,
  });
}

/// High-performance 120 FPS Starfield Painter drawing realistic, living celestial pinpoints.
class _CelestialStarfieldPainter extends CustomPainter {
  final Animation<double> animation;

  _CelestialStarfieldPainter({required this.animation})
    : super(repaint: animation);

  // Carefully balanced constellation of 31 celestial bodies framing the sacred space
  static const List<_StarParticle> _stars = [
    // --- Upper Expanse (Deep Midnight Sky) ---
    _StarParticle(
      x: 0.09,
      y: 0.08,
      radius: 0.7,
      minAlpha: 0.25,
      maxAlpha: 0.70,
      twinkleFreq: 2.0,
      twinklePhase: 0.4,
      driftRadiusX: 4.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.22,
      y: 0.12,
      radius: 0.8,
      minAlpha: 0.30,
      maxAlpha: 0.80,
      twinkleFreq: 3.0,
      twinklePhase: 1.2,
      driftRadiusX: 5.0,
      driftRadiusY: 3.0,
    ),
    _StarParticle(
      x: 0.38,
      y: 0.06,
      radius: 0.6,
      minAlpha: 0.20,
      maxAlpha: 0.60,
      twinkleFreq: 1.0,
      twinklePhase: 2.5,
      driftRadiusX: 3.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.52,
      y: 0.10,
      radius: 1.3,
      minAlpha: 0.40,
      maxAlpha: 0.95,
      twinkleFreq: 2.0,
      twinklePhase: 0.0,
      driftRadiusX: 6.0,
      driftRadiusY: 3.5,
      hasGlow: true,
      hasSparkle: true,
    ),
    _StarParticle(
      x: 0.68,
      y: 0.07,
      radius: 0.7,
      minAlpha: 0.25,
      maxAlpha: 0.65,
      twinkleFreq: 2.5,
      twinklePhase: 3.8,
      driftRadiusX: 4.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.82,
      y: 0.13,
      radius: 1.1,
      minAlpha: 0.35,
      maxAlpha: 0.90,
      twinkleFreq: 1.5,
      twinklePhase: 4.5,
      driftRadiusX: 5.0,
      driftRadiusY: 3.0,
      hasGlow: true,
    ),
    _StarParticle(
      x: 0.94,
      y: 0.09,
      radius: 0.6,
      minAlpha: 0.20,
      maxAlpha: 0.55,
      twinkleFreq: 3.0,
      twinklePhase: 5.1,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),

    // --- Upper-Mid Transition ---
    _StarParticle(
      x: 0.14,
      y: 0.24,
      radius: 1.2,
      minAlpha: 0.35,
      maxAlpha: 0.90,
      twinkleFreq: 2.0,
      twinklePhase: 2.0,
      driftRadiusX: 5.0,
      driftRadiusY: 2.5,
      hasGlow: true,
      hasSparkle: true,
    ),
    _StarParticle(
      x: 0.30,
      y: 0.20,
      radius: 0.65,
      minAlpha: 0.20,
      maxAlpha: 0.60,
      twinkleFreq: 1.5,
      twinklePhase: 0.8,
      driftRadiusX: 3.5,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.45,
      y: 0.25,
      radius: 0.8,
      minAlpha: 0.30,
      maxAlpha: 0.75,
      twinkleFreq: 3.5,
      twinklePhase: 3.1,
      driftRadiusX: 4.5,
      driftRadiusY: 3.0,
    ),
    _StarParticle(
      x: 0.60,
      y: 0.22,
      radius: 0.7,
      minAlpha: 0.25,
      maxAlpha: 0.65,
      twinkleFreq: 2.0,
      twinklePhase: 4.9,
      driftRadiusX: 3.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.76,
      y: 0.26,
      radius: 0.85,
      minAlpha: 0.30,
      maxAlpha: 0.80,
      twinkleFreq: 1.0,
      twinklePhase: 1.7,
      driftRadiusX: 5.0,
      driftRadiusY: 2.5,
    ),
    _StarParticle(
      x: 0.89,
      y: 0.21,
      radius: 0.65,
      minAlpha: 0.20,
      maxAlpha: 0.55,
      twinkleFreq: 2.5,
      twinklePhase: 3.3,
      driftRadiusX: 4.0,
      driftRadiusY: 2.0,
    ),

    // --- Flanking Side Wings (Framing Holy Ayah) ---
    _StarParticle(
      x: 0.05,
      y: 0.38,
      radius: 0.9,
      minAlpha: 0.30,
      maxAlpha: 0.85,
      twinkleFreq: 2.0,
      twinklePhase: 0.5,
      driftRadiusX: 4.0,
      driftRadiusY: 3.0,
    ),
    _StarParticle(
      x: 0.12,
      y: 0.48,
      radius: 1.4,
      minAlpha: 0.40,
      maxAlpha: 1.0,
      twinkleFreq: 1.5,
      twinklePhase: 5.5,
      driftRadiusX: 6.0,
      driftRadiusY: 3.5,
      hasGlow: true,
      hasSparkle: true,
    ),
    _StarParticle(
      x: 0.07,
      y: 0.60,
      radius: 0.7,
      minAlpha: 0.20,
      maxAlpha: 0.60,
      twinkleFreq: 3.0,
      twinklePhase: 2.3,
      driftRadiusX: 3.5,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.15,
      y: 0.68,
      radius: 0.8,
      minAlpha: 0.25,
      maxAlpha: 0.70,
      twinkleFreq: 2.0,
      twinklePhase: 4.1,
      driftRadiusX: 4.0,
      driftRadiusY: 2.5,
    ),
    _StarParticle(
      x: 0.92,
      y: 0.40,
      radius: 0.85,
      minAlpha: 0.25,
      maxAlpha: 0.75,
      twinkleFreq: 2.5,
      twinklePhase: 1.9,
      driftRadiusX: 4.5,
      driftRadiusY: 2.5,
    ),
    _StarParticle(
      x: 0.85,
      y: 0.52,
      radius: 1.3,
      minAlpha: 0.40,
      maxAlpha: 0.95,
      twinkleFreq: 2.0,
      twinklePhase: 3.7,
      driftRadiusX: 5.5,
      driftRadiusY: 3.0,
      hasGlow: true,
      hasSparkle: true,
    ),
    _StarParticle(
      x: 0.95,
      y: 0.62,
      radius: 0.65,
      minAlpha: 0.20,
      maxAlpha: 0.55,
      twinkleFreq: 1.5,
      twinklePhase: 0.3,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),
    _StarParticle(
      x: 0.87,
      y: 0.70,
      radius: 0.8,
      minAlpha: 0.30,
      maxAlpha: 0.75,
      twinkleFreq: 3.0,
      twinklePhase: 4.8,
      driftRadiusX: 4.0,
      driftRadiusY: 2.5,
    ),

    // --- Subtle Ambient Stardust in Center Expanse ---
    _StarParticle(
      x: 0.26,
      y: 0.36,
      radius: 0.6,
      minAlpha: 0.15,
      maxAlpha: 0.50,
      twinkleFreq: 2.0,
      twinklePhase: 1.4,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),
    _StarParticle(
      x: 0.71,
      y: 0.38,
      radius: 0.65,
      minAlpha: 0.15,
      maxAlpha: 0.50,
      twinkleFreq: 1.5,
      twinklePhase: 2.8,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),
    _StarParticle(
      x: 0.35,
      y: 0.64,
      radius: 0.7,
      minAlpha: 0.20,
      maxAlpha: 0.60,
      twinkleFreq: 2.5,
      twinklePhase: 5.0,
      driftRadiusX: 3.5,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.64,
      y: 0.63,
      radius: 0.6,
      minAlpha: 0.18,
      maxAlpha: 0.55,
      twinkleFreq: 1.8,
      twinklePhase: 0.9,
      driftRadiusX: 3.0,
      driftRadiusY: 1.8,
    ),

    // --- Lower Atmospheric Belt (Above Prayer Bar) ---
    _StarParticle(
      x: 0.08,
      y: 0.80,
      radius: 0.75,
      minAlpha: 0.25,
      maxAlpha: 0.70,
      twinkleFreq: 2.0,
      twinklePhase: 3.2,
      driftRadiusX: 4.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.23,
      y: 0.78,
      radius: 1.1,
      minAlpha: 0.35,
      maxAlpha: 0.85,
      twinkleFreq: 1.5,
      twinklePhase: 1.0,
      driftRadiusX: 5.0,
      driftRadiusY: 2.5,
      hasGlow: true,
    ),
    _StarParticle(
      x: 0.42,
      y: 0.82,
      radius: 0.6,
      minAlpha: 0.18,
      maxAlpha: 0.50,
      twinkleFreq: 2.5,
      twinklePhase: 4.2,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),
    _StarParticle(
      x: 0.58,
      y: 0.77,
      radius: 0.8,
      minAlpha: 0.25,
      maxAlpha: 0.75,
      twinkleFreq: 3.0,
      twinklePhase: 2.6,
      driftRadiusX: 4.0,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.75,
      y: 0.83,
      radius: 0.7,
      minAlpha: 0.20,
      maxAlpha: 0.65,
      twinkleFreq: 1.8,
      twinklePhase: 0.6,
      driftRadiusX: 3.5,
      driftRadiusY: 2.0,
    ),
    _StarParticle(
      x: 0.90,
      y: 0.82,
      radius: 0.65,
      minAlpha: 0.20,
      maxAlpha: 0.55,
      twinkleFreq: 2.2,
      twinklePhase: 3.9,
      driftRadiusX: 3.0,
      driftRadiusY: 1.5,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;

    for (final star in _stars) {
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

/// Pinned Top Bar ensuring brand identity and audio recitation trigger remain accessible.
class _CelestialTopBar extends StatelessWidget {
  final double subtitleOpacity;
  final bool isPlaying;
  final VoidCallback onToggleRecitation;

  const _CelestialTopBar({
    required this.subtitleOpacity,
    required this.isPlaying,
    required this.onToggleRecitation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Right Side (RTL Start): Sakina Brand Mark
          _CelestialBrandBadge(subtitleOpacity: subtitleOpacity),

          // 2. Left Side (RTL End): Translucent Frosted Glass Play/Pause Recitation Button
          _CelestialPlayButton(isPlaying: isPlaying, onTap: onToggleRecitation),
        ],
      ),
    );
  }
}

/// Minimalist luxury brand crest adapting between expanded display and compact pinned state.
class _CelestialBrandBadge extends StatelessWidget {
  final double subtitleOpacity;

  const _CelestialBrandBadge({required this.subtitleOpacity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Frosted Glass Crescent Emblem Medallion
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.champagneGold.withValues(alpha: 0.35),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              FlutterIslamicIcons.solidCrescentMoon,
              color: AppColors.champagneGold,
              size: 18.r,
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Brand Title & Subtitle in Clean High-Contrast Typography
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'سَكِينَة',
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  height: 1.15,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitleOpacity > 0.05)
                Opacity(
                  opacity: subtitleOpacity,
                  child: Text(
                    'مَلَاذُ الرُّوحِ',
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF94A3B8),
                      fontSize: 9.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sleek frosted glass Play/Pause button matching reference design (Zero drop shadows).
class _CelestialPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _CelestialPlayButton({required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: isPlaying
                ? AppColors.champagneGold.withValues(alpha: 0.22)
                : Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: isPlaying
                  ? AppColors.champagneGold
                  : Colors.white.withValues(alpha: 0.18),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22.r,
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean Quranic Ayah presentation matching reference photo (Pure white text without brackets).
class _CelestialAyahCard extends StatelessWidget {
  final String verseText;
  final String surahSource;

  const _CelestialAyahCard({
    required this.verseText,
    required this.surahSource,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pure Holy Ayah Text (White, High-Contrast, No Brackets)
          Text(
            verseText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.85,
              letterSpacing: 0.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          // Delicate Surah Citation in Soft Champagne Gold
          Text(
            surahSource,
            style: GoogleFonts.cairo(
              color: AppColors.champagneGold,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
