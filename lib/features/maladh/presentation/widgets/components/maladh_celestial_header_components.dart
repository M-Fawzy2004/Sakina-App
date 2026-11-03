import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Pinned Top Bar ensuring brand identity and audio recitation trigger remain accessible.
class CelestialTopBar extends StatelessWidget {
  final double subtitleOpacity;
  final bool isPlaying;
  final VoidCallback onToggleRecitation;

  const CelestialTopBar({
    super.key,
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
          CelestialBrandBadge(subtitleOpacity: subtitleOpacity),

          // 2. Left Side (RTL End): Translucent Frosted Glass Play/Pause Recitation Button
          CelestialPlayButton(
            isPlaying: isPlaying,
            onTap: onToggleRecitation,
          ),
        ],
      ),
    );
  }
}

/// Minimalist luxury brand crest adapting between expanded display and compact pinned state.
class CelestialBrandBadge extends StatelessWidget {
  final double subtitleOpacity;

  const CelestialBrandBadge({
    super.key,
    required this.subtitleOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Frosted Glass Crescent Emblem Medallion
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: colors.surfaceElevated.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.accentGold.withValues(alpha: 0.4),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              FlutterIslamicIcons.solidCrescentMoon,
              color: colors.accentGold,
              size: 18.r,
            ),
          ),
        ),

        SizedBox(width: 8.w),

        // Brand Title & Subtitle in Clean Theme-Aware Typography
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
                style: GoogleFonts.almarai(
                  fontSize: 18.sp,
                  height: 1.15,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitleOpacity > 0.05)
                Opacity(
                  opacity: subtitleOpacity,
                  child: Text(
                    'مَلَاذُ الرُّوحِ',
                    style: GoogleFonts.almarai(
                      color: colors.textSecondary,
                      fontSize: 9.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
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

/// Sleek frosted glass Play/Pause button matching reference design (Theme-adaptive).
class CelestialPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const CelestialPlayButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                ? colors.accentGold.withValues(alpha: 0.22)
                : colors.surfaceElevated.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isPlaying ? colors.accentGold : colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: isPlaying ? colors.accentGold : colors.textPrimary,
              size: 22.r,
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean Quranic Ayah presentation matching reference photo (Theme-adaptive typography).
class CelestialAyahCard extends StatelessWidget {
  final String verseText;
  final String surahSource;

  const CelestialAyahCard({
    super.key,
    required this.verseText,
    required this.surahSource,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Holy Ayah Text (Classical Amiri Naskh, Large, Crystal-Clear)
          Text(
            verseText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              height: 1.75,
              letterSpacing: 0.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          // Delicate Surah Citation in Soft Champagne/Warm Gold (Almarai)
          Text(
            surahSource,
            textAlign: TextAlign.center,
            style: GoogleFonts.almarai(
              color: colors.accentGold,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

