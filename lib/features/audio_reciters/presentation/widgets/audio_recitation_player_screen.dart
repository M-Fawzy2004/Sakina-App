import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/audio_player_settings_sheet.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_audio_waveform.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_scrubber_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Full-screen independent spiritual recitation player with gesture dismiss and floating utility capsule.
class AudioRecitationPlayerScreen extends StatefulWidget {
  final RecitationTrackEntity? initialTrack;

  const AudioRecitationPlayerScreen({
    super.key,
    this.initialTrack,
  });

  @override
  State<AudioRecitationPlayerScreen> createState() => _AudioRecitationPlayerScreenState();
}

class _AudioRecitationPlayerScreenState extends State<AudioRecitationPlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleVerticalDrag(DragUpdateDetails details) {
    if (details.primaryDelta != null && details.primaryDelta! > 12) {
      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
    }
  }

  void _openSettingsSheet(BuildContext context, AudioRecitersCubit cubit, AudioRecitersState state) {
    AudioPlayerSettingsSheet.show(
      context: context,
      currentSpeed: state.playbackSpeed,
      sleepTimerMinutes: state.sleepTimerMinutes,
      isRepeating: state.isRepeating,
      onSpeedSelected: cubit.setPlaybackSpeed,
      onSleepTimerSelected: cubit.setSleepTimer,
      onToggleRepeat: cubit.toggleRepeat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioRecitersCubit, AudioRecitersState>(
      listener: (context, state) {
        if (state.isPlaying) {
          if (!_rotationController.isAnimating) {
            _rotationController.repeat();
          }
        } else {
          _rotationController.stop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AudioRecitersCubit>();
        final track = state.currentTrack ?? widget.initialTrack;

        return Scaffold(
          backgroundColor: context.colors.background,
          body: GestureDetector(
            onVerticalDragUpdate: _handleVerticalDrag,
            child: SafeArea(
              child: track == null
                  ? const _NoTrackPlaceholder()
                  : Column(
                      children: [
                        // Drag dismiss indicator bar
                        _TopDragBar(onTap: () => Navigator.of(context).pop()),

                        // Top Navigation Header
                        _PlayerTopAppBar(
                          onBackTap: () => Navigator.of(context).pop(),
                          onSettingsTap: () => _openSettingsSheet(context, cubit, state),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Animated Rotating Central Medallion
                                _AnimatedPlayerMedallion(
                                  reciterName: track.reciterName,
                                  isPlaying: state.isPlaying,
                                  rotationAnimation: _rotationController,
                                ),

                                // Track & Reciter Calligraphy Typography
                                _PlayerTypography(
                                  reciterName: track.reciterName,
                                  styleDescription: track.styleDescription,
                                ),

                                // Dynamic Glowing Acoustic Audio Waveform
                                RecitationAudioWaveform(
                                  isPlaying: state.isPlaying,
                                ),

                                // Audio Position Scrubber Bar
                                RecitationScrubberBar(
                                  position: state.position,
                                  duration: state.duration,
                                  onSeek: cubit.seekTo,
                                ),

                                // Concentric Playback Controls
                                RecitationPlaybackControls(
                                  isPlaying: state.isPlaying,
                                  isBuffering: state.isBuffering,
                                  isRepeating: state.isRepeating,
                                  isShuffling: state.isShuffling,
                                  onPlayPause: cubit.togglePlayPause,
                                  onNext: cubit.nextTrack,
                                  onPrevious: cubit.previousTrack,
                                  onToggleRepeat: cubit.toggleRepeat,
                                  onToggleShuffle: cubit.toggleShuffle,
                                ),

                                // Floating Luxury Utility Capsule (Side-by-side Speed, Timer, Repeat, Settings)
                                _FloatingUtilityCapsule(
                                  currentSpeed: state.playbackSpeed,
                                  sleepTimerMinutes: state.sleepTimerMinutes,
                                  isRepeating: state.isRepeating,
                                  onSpeedChanged: cubit.setPlaybackSpeed,
                                  onSleepTimerChanged: cubit.setSleepTimer,
                                  onToggleRepeat: cubit.toggleRepeat,
                                  onOpenSettings: () => _openSettingsSheet(context, cubit, state),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _TopDragBar extends StatelessWidget {
  final VoidCallback onTap;

  const _TopDragBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        alignment: Alignment.center,
        child: Container(
          width: 38.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.mutedSilver.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

class _PlayerTopAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onSettingsTap;

  const _PlayerTopAppBar({
    required this.onBackTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.arrow_right_3,
                color: colors.accentGold,
                size: 20.r,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مشغل التلاوة',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '🌙',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.setting_2,
                color: colors.accentGold,
                size: 19.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedPlayerMedallion extends StatelessWidget {
  final String reciterName;
  final bool isPlaying;
  final Animation<double> rotationAnimation;

  const _AnimatedPlayerMedallion({
    required this.reciterName,
    required this.isPlaying,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.r,
      height: 190.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPlaying ? AppColors.champagneGold : AppColors.goldBorderStroke,
          width: 2.r,
        ),
        gradient: const RadialGradient(
          colors: [
            AppColors.carbonSlate,
            AppColors.obsidianCore,
          ],
        ),
      ),
      padding: EdgeInsets.all(6.r),
      child: RotationTransition(
        turns: rotationAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldBorderStroke,
              width: 1.5.r,
            ),
          ),
          padding: EdgeInsets.all(6.r),
          child: ReciterAvatarMedallion(
            nameArabic: reciterName,
            size: 160,
            isGlowing: isPlaying,
          ),
        ),
      ),
    );
  }
}

class _PlayerTypography extends StatelessWidget {
  final String reciterName;
  final String styleDescription;

  const _PlayerTypography({
    required this.reciterName,
    required this.styleDescription,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reciterName,
          style: GoogleFonts.cairo(
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        Text(
          styleDescription,
          style: GoogleFonts.amiri(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: colors.accentGold,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Floating luxury stadium capsule holding utility controls side-by-side
class _FloatingUtilityCapsule extends StatelessWidget {
  final double currentSpeed;
  final int? sleepTimerMinutes;
  final bool isRepeating;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<int?> onSleepTimerChanged;
  final VoidCallback onToggleRepeat;
  final VoidCallback onOpenSettings;

  const _FloatingUtilityCapsule({
    required this.currentSpeed,
    required this.sleepTimerMinutes,
    required this.isRepeating,
    required this.onSpeedChanged,
    required this.onSleepTimerChanged,
    required this.onToggleRepeat,
    required this.onOpenSettings,
  });

  void _cycleSpeed() {
    HapticFeedback.lightImpact();
    const speeds = [1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(currentSpeed);
    final nextSpeed = (currentIndex >= 0 && currentIndex < speeds.length - 1)
        ? speeds[currentIndex + 1]
        : speeds.first;
    onSpeedChanged(nextSpeed);
  }

  void _cycleSleepTimer() {
    HapticFeedback.lightImpact();
    final timers = <int?>[null, 15, 30, 45, 60];
    final currentIndex = timers.indexOf(sleepTimerMinutes);
    final nextTimer = (currentIndex >= 0 && currentIndex < timers.length - 1)
        ? timers[currentIndex + 1]
        : timers.first;
    onSleepTimerChanged(nextTimer);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Quick Speed Toggle Pill (Changes speed immediately on tap)
          GestureDetector(
            onTap: _cycleSpeed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: currentSpeed != 1.0 ? colors.surfaceElevated : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: currentSpeed != 1.0 ? colors.accentGold : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.speedometer,
                    size: 16.r,
                    color: currentSpeed != 1.0 ? colors.accentGold : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${currentSpeed}x',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: currentSpeed != 1.0 ? colors.accentGold : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 2. Quick Sleep Timer Toggle Pill
          GestureDetector(
            onTap: _cycleSleepTimer,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: sleepTimerMinutes != null ? colors.surfaceElevated : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: sleepTimerMinutes != null ? colors.accentGold : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.timer_1,
                    size: 16.r,
                    color: sleepTimerMinutes != null ? colors.accentGold : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    sleepTimerMinutes != null ? '$sleepTimerMinutes د' : 'المؤقت',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: sleepTimerMinutes != null ? colors.accentGold : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 3. Quick Repeat Mode Toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onToggleRepeat();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isRepeating ? colors.surfaceElevated : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isRepeating ? colors.accentGold : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.repeate_one,
                size: 18.r,
                color: isRepeating ? colors.accentGold : colors.textSecondary,
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 4. Quick Full Settings Opener
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onOpenSettings();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Icon(
                Iconsax.setting_2,
                size: 18.r,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoTrackPlaceholder extends StatelessWidget {
  const _NoTrackPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا يوجد مقطع صوتي محدد',
        style: GoogleFonts.cairo(
          color: AppColors.mutedSilver,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
