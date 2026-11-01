import 'dart:async';
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
      _playerStateSubscription =
          _audioHandler?.playerStateStream.listen((state) {
        if (!mounted) return;
        final playing = state.playing &&
            state.processingState != ProcessingState.completed;
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
    final minHeight = 56.h + topPadding;
    final maxHeight = 245.h + topPadding;

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

    // Smooth early fade: Ayah fades out completely over first 75px of scroll
    // so it never collides with the top bar or gets sliced by the edge!
    final verseOpacity = (1.0 - (shrinkOffset / 75.h)).clamp(0.0, 1.0);
    final starOpacity = (1.0 - (shrinkOffset / 115.h)).clamp(0.0, 1.0);
    final subtitleOpacity = (1.0 - (shrinkOffset / 40.h)).clamp(0.0, 1.0);

    return Container(
      // Keep exact matching canvas background with zero elevation tint
      color: colors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Deep Seamless Midnight Night Sky with realistic tiny stars (Zero shadows/banding)
          if (starOpacity > 0.01)
            Opacity(
              opacity: starOpacity,
              child: _CelestialNightSkyBackground(
                isDark: colors.isDark,
              ),
            ),

          // 2. Center Prominent Quranic Ayah (Fades gracefully as soon as scroll begins)
          if (verseOpacity > 0.01)
            Positioned(
              top: topPadding + 54.h,
              left: 16.w,
              right: 16.w,
              height: 160.h,
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

/// Atmospheric seamless midnight sky background with realistic, tiny, faint stars.
class _CelestialNightSkyBackground extends StatelessWidget {
  final bool isDark;

  const _CelestialNightSkyBackground({
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (!isDark) {
      return Container(
        color: colors.background,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Seamless uniform midnight canvas matching scaffold background
        Container(
          color: colors.background,
        ),

        // Constellation Starfield Custom Painter (subtle white pinpoints)
        const CustomPaint(
          painter: _CelestialStarfieldPainter(),
        ),
      ],
    );
  }
}

/// High-performance 120 FPS Starfield Painter drawing tiny, realistic white celestial pinpoints.
class _CelestialStarfieldPainter extends CustomPainter {
  const _CelestialStarfieldPainter();

  // Pre-calculated normalized star positions with tiny radii (0.6 - 0.9 px) and soft alpha
  static const List<({double x, double y, double r, double a})> _stars = [
    (x: 0.08, y: 0.22, r: 0.7, a: 0.60),
    (x: 0.18, y: 0.45, r: 0.8, a: 0.70),
    (x: 0.28, y: 0.16, r: 0.6, a: 0.40),
    (x: 0.36, y: 0.72, r: 0.7, a: 0.50),
    (x: 0.44, y: 0.28, r: 0.9, a: 0.75),
    (x: 0.53, y: 0.14, r: 0.6, a: 0.40),
    (x: 0.62, y: 0.55, r: 0.8, a: 0.65),
    (x: 0.72, y: 0.25, r: 0.7, a: 0.55),
    (x: 0.82, y: 0.65, r: 0.9, a: 0.75),
    (x: 0.90, y: 0.32, r: 0.6, a: 0.45),
    (x: 0.12, y: 0.80, r: 0.6, a: 0.35),
    (x: 0.22, y: 0.62, r: 0.7, a: 0.60),
    (x: 0.48, y: 0.82, r: 0.6, a: 0.45),
    (x: 0.68, y: 0.84, r: 0.8, a: 0.65),
    (x: 0.85, y: 0.16, r: 0.8, a: 0.70),
    (x: 0.94, y: 0.74, r: 0.6, a: 0.35),
    (x: 0.05, y: 0.52, r: 0.7, a: 0.50),
    (x: 0.38, y: 0.58, r: 0.6, a: 0.30),
    (x: 0.56, y: 0.36, r: 0.7, a: 0.55),
    (x: 0.78, y: 0.42, r: 0.6, a: 0.45),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in _stars) {
      paint.color = Colors.white.withValues(alpha: star.a);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CelestialStarfieldPainter oldDelegate) => false;
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
          _CelestialPlayButton(
            isPlaying: isPlaying,
            onTap: onToggleRecitation,
          ),
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

  const _CelestialPlayButton({
    required this.isPlaying,
    required this.onTap,
  });

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
