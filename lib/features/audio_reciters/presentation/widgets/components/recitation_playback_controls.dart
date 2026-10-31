import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Central playback controls with illuminated concentric golden Play/Pause button.
class RecitationPlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final bool isRepeating;
  final bool isShuffling;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onToggleRepeat;
  final VoidCallback onToggleShuffle;

  const RecitationPlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.isRepeating,
    required this.isShuffling,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onToggleRepeat,
    required this.onToggleShuffle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Repeat Toggle
          _AuxiliaryButton(
            icon: Iconsax.repeate_one,
            isActive: isRepeating,
            onTap: onToggleRepeat,
          ),

          // Previous Track
          _SkipButton(
            icon: Iconsax.previous,
            onTap: onPrevious,
          ),

          // Center Large Concentric Play/Pause Button
          _CenterPlayPauseButton(
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            onTap: onPlayPause,
          ),

          // Next Track
          _SkipButton(
            icon: Iconsax.next,
            onTap: onNext,
          ),

          // Shuffle Toggle
          _AuxiliaryButton(
            icon: Iconsax.shuffle,
            isActive: isShuffling,
            onTap: onToggleShuffle,
          ),
        ],
      ),
    );
  }
}

class _CenterPlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onTap;

  const _CenterPlayPauseButton({
    required this.isPlaying,
    required this.isBuffering,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.r,
        height: 72.r,
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
                    width: 24.r,
                    height: 24.r,
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

class _SkipButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SkipButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.frostedGlass,
          border: Border.all(
            color: AppColors.goldBorderStroke,
            width: 1.r,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.pureChalk,
          size: 20.r,
        ),
      ),
    );
  }
}

class _AuxiliaryButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _AuxiliaryButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.surfaceElevated : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColors.champagneGold : Colors.transparent,
            width: 1.r,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.champagneGold : AppColors.mutedSilver,
          size: 20.r,
        ),
      ),
    );
  }
}

