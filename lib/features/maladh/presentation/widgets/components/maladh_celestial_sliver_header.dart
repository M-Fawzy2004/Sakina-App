import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/audio/audio_player_handler.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/celestial_starfield_background.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_celestial_header_components.dart';
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
    final minHeight = 54.h + 74.h + topPadding;
    final maxHeight = 240.h + 74.h + topPadding;

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

    return Container(
      // Keep exact matching canvas background with zero elevation tint
      color: colors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Deep Seamless Midnight Night Sky with realistic tiny animated stars
          Opacity(
            opacity: starOpacity,
            child: CelestialNightSkyBackground(
              key: const ValueKey('celestial_night_sky'),
              isDark: colors.isDark,
            ),
          ),

          // 2. Center Prominent Quranic Ayah (Fades gracefully as soon as scroll begins)
          if (verseOpacity > 0.01)
            Positioned(
              top: topPadding + 50.h,
              left: 16.w,
              right: 16.w,
              height: 180.h,
              child: Opacity(
                opacity: verseOpacity,
                child: Transform.translate(
                  offset: Offset(0, -18.h * (1.0 - verseOpacity)),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CelestialAyahCard(
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
            child: CelestialTopBar(
              subtitleOpacity: subtitleOpacity,
              isPlaying: isPlaying,
              onToggleRecitation: onToggleRecitation,
            ),
          ),

          // 4. Luxury Prayer Context & Countdown Bar
          // Glued flush to the bottom of the sliver header with zero gap
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
