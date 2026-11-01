import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Luxury live sanctuary playback controls without bulky side cards.
/// Provides pure circular controls for play/pause, channel skipping, reconnecting, and toggling.
class LiveSanctuaryPlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final bool isMakkah;
  final VoidCallback onPlayPause;
  final VoidCallback onSwitchToMakkah;
  final VoidCallback onSwitchToMadinah;
  final VoidCallback onReconnect;

  const LiveSanctuaryPlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.isMakkah,
    required this.onPlayPause,
    required this.onSwitchToMakkah,
    required this.onSwitchToMadinah,
    required this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Reconnect / Stream Refresh Button
          _AuxiliaryLiveIconButton(
            icon: Iconsax.refresh,
            onTap: onReconnect,
          ),

          // 2. Previous Sanctuary Channel (Switches between Makkah and Madinah)
          _SanctuarySkipButton(
            icon: Iconsax.previous,
            onTap: isMakkah ? onSwitchToMadinah : onSwitchToMakkah,
          ),

          // 3. Grand Concentric Live Play/Pause Button
          _LiveCenterPlayPauseButton(
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            onTap: onPlayPause,
          ),

          // 4. Next Sanctuary Channel (Switches between Makkah and Madinah)
          _SanctuarySkipButton(
            icon: Iconsax.next,
            onTap: isMakkah ? onSwitchToMadinah : onSwitchToMakkah,
          ),

          // 5. Quick Channel Swap Button
          _AuxiliaryLiveIconButton(
            icon: Iconsax.repeat,
            onTap: isMakkah ? onSwitchToMadinah : onSwitchToMakkah,
          ),
        ],
      ),
    );
  }
}

class _SanctuarySkipButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SanctuarySkipButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        onTap();
      },
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.cardSurface,
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Icon(
          icon,
          color: colors.textPrimary,
          size: 22.r,
        ),
      ),
    );
  }
}

class _AuxiliaryLiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AuxiliaryLiveIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        onTap();
      },
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.cardSurface,
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Icon(
          icon,
          color: colors.textSecondary,
          size: 19.r,
        ),
      ),
    );
  }
}

class _LiveCenterPlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onTap;

  const _LiveCenterPlayPauseButton({
    required this.isPlaying,
    required this.isBuffering,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.mediumImpact();
        onTap();
      },
      child: Container(
        width: 74.r,
        height: 74.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.champagneGold,
            width: 2.r,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.paleRadiance,
              AppColors.champagneGold,
            ],
          ),
        ),
        padding: EdgeInsets.all(4.r),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.obsidianCore,
              width: 1.5.r,
            ),
            color: AppColors.champagneGold,
          ),
          child: isBuffering
              ? Center(
                  child: SizedBox(
                    width: 26.r,
                    height: 26.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5.r,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.obsidianCore),
                    ),
                  ),
                )
              : Icon(
                  isPlaying ? Iconsax.pause : Iconsax.play,
                  color: AppColors.obsidianCore,
                  size: 32.r,
                ),
        ),
      ),
    );
  }
}
