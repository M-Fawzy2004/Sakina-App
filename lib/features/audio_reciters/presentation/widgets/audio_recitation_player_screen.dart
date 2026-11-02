import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/animated_player_medallion.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/audio_player_settings_sheet.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_broadcast_status_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_sanctuary_aura_medallion.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_sanctuary_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_stream_channels_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/player_top_app_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/player_utility_capsules.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_audio_waveform.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_playback_controls.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/recitation_scrubber_bar.dart';

/// Full-screen independent spiritual recitation and live sanctuary player.
/// Features zero drop-shadows, animated expanding aura rings, and adaptive controls for live broadcasts.
class AudioRecitationPlayerScreen extends StatefulWidget {
  final RecitationTrackEntity? initialTrack;

  const AudioRecitationPlayerScreen({
    super.key,
    this.initialTrack,
  });

  @override
  State<AudioRecitationPlayerScreen> createState() =>
      _AudioRecitationPlayerScreenState();
}

class _AudioRecitationPlayerScreenState
    extends State<AudioRecitationPlayerScreen>
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
      HapticService.lightImpact();
      Navigator.of(context).pop();
    }
  }

  void _openSettingsSheet(
    BuildContext context,
    AudioRecitersCubit cubit,
    AudioRecitersState state,
    bool isLive,
  ) {
    AudioPlayerSettingsSheet.show(
      context: context,
      isLive: isLive,
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

        final isLiveStream = track != null &&
            (track.surahId == 0 ||
                track.reciterId == 999 ||
                track.riwayah.contains('بث مباشر') ||
                track.audioUrl.contains('.m3u8'));

        final isMakkah = track != null &&
            (track.audioUrl.contains('quran') ||
                track.reciterName.contains('مكة'));

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
                        PlayerTopDragBar(onTap: () => Navigator.of(context).pop()),

                        // Top Navigation Header
                        PlayerTopAppBar(
                          isLive: isLiveStream,
                          onBackTap: () => Navigator.of(context).pop(),
                          onSettingsTap: () => _openSettingsSheet(
                            context,
                            cubit,
                            state,
                            isLiveStream,
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // 1. Central Medallion (Spiritual Aura if Live, Avatar if Reciter)
                                if (isLiveStream)
                                  LiveSanctuaryAuraMedallion(
                                    isMakkah: isMakkah,
                                    isPlaying: state.isPlaying,
                                    rotationAnimation: _rotationController,
                                  )
                                else
                                  AnimatedPlayerMedallion(
                                    reciterName: track.reciterName,
                                    isPlaying: state.isPlaying,
                                    rotationAnimation: _rotationController,
                                  ),

                                // 2. Track & Reciter Typography
                                PlayerTypography(
                                  isLive: isLiveStream,
                                  reciterName: track.reciterName,
                                  styleDescription: track.styleDescription,
                                ),

                                // 3. Dynamic Glowing Acoustic Audio Waveform
                                RecitationAudioWaveform(
                                  isPlaying: state.isPlaying,
                                  isLive: isLiveStream,
                                ),

                                // 4. Scrubber Bar or Live Status Bar (Zero seconds for Live Streams)
                                if (isLiveStream)
                                  LiveBroadcastStatusBar(
                                    isPlaying: state.isPlaying,
                                  )
                                else
                                  RecitationScrubberBar(
                                    position: state.position,
                                    duration: state.duration,
                                    onSeek: cubit.seekTo,
                                  ),

                                // 5. Playback Controls (Sanctuary Controls if Live, Standard if Reciter)
                                if (isLiveStream)
                                  LiveSanctuaryPlaybackControls(
                                    isPlaying: state.isPlaying,
                                    isBuffering: state.isBuffering,
                                    isMakkah: isMakkah,
                                    onPlayPause: cubit.togglePlayPause,
                                    onSwitchToMakkah: () => cubit.playTrack(
                                      kSanctuaryLiveChannels[0].toTrack(),
                                    ),
                                    onSwitchToMadinah: () => cubit.playTrack(
                                      kSanctuaryLiveChannels[1].toTrack(),
                                    ),
                                    onReconnect: () => cubit.playTrack(track),
                                  )
                                else
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

                                // 6. Utility Capsule
                                if (isLiveStream)
                                  LiveUtilityCapsule(
                                    sleepTimerMinutes: state.sleepTimerMinutes,
                                    isMakkah: isMakkah,
                                    onSleepTimerChanged: cubit.setSleepTimer,
                                    onToggleSanctuary: () {
                                      final target = isMakkah
                                          ? kSanctuaryLiveChannels[1]
                                          : kSanctuaryLiveChannels[0];
                                      cubit.playTrack(target.toTrack());
                                    },
                                    onOpenSettings: () => _openSettingsSheet(
                                      context,
                                      cubit,
                                      state,
                                      true,
                                    ),
                                  )
                                else
                                  FloatingUtilityCapsule(
                                    currentSpeed: state.playbackSpeed,
                                    sleepTimerMinutes: state.sleepTimerMinutes,
                                    isRepeating: state.isRepeating,
                                    onSpeedChanged: cubit.setPlaybackSpeed,
                                    onSleepTimerChanged: cubit.setSleepTimer,
                                    onToggleRepeat: cubit.toggleRepeat,
                                    onOpenSettings: () => _openSettingsSheet(
                                      context,
                                      cubit,
                                      state,
                                      false,
                                    ),
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
