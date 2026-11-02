import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Animated rotating medallion with glowing avatar for the audio player.
class AnimatedPlayerMedallion extends StatelessWidget {
  final String reciterName;
  final bool isPlaying;
  final Animation<double> rotationAnimation;

  const AnimatedPlayerMedallion({
    super.key,
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

/// Large prominent typography for reciter name and Surah/station name.
class PlayerTypography extends StatelessWidget {
  final bool isLive;
  final String reciterName;
  final String styleDescription;

  const PlayerTypography({
    super.key,
    required this.isLive,
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
            fontSize: isLive ? 20.sp : 21.sp,
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

