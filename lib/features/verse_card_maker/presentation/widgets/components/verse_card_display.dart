import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_watermark.dart';
import 'package:video_player/video_player.dart';

/// The central card canvas rendered for viewing and high-resolution export.
/// Supports 10 preset celestial backgrounds, custom gallery images, or looping video reels.
/// Strictly zero drop shadows with anti-aliased clean edge boundaries.
class VerseCardDisplay extends StatelessWidget {
  final GlobalKey cardKey;
  final VerseCardItem verse;
  final String? presetAsset;
  final File? customImageFile;
  final VideoPlayerController? videoController;
  final String reciterName;
  final bool isPlayingRecitation;
  final bool isOverlayOnly;

  const VerseCardDisplay({
    super.key,
    required this.cardKey,
    required this.verse,
    this.presetAsset,
    this.customImageFile,
    this.videoController,
    required this.reciterName,
    required this.isPlayingRecitation,
    this.isOverlayOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isOverlayOnly ? Colors.transparent : AppColors.obsidianCore,
          borderRadius: BorderRadius.circular(22.r),
          border: isOverlayOnly
              ? null
              : Border.all(
                  color: colors.accentGold.withValues(alpha: 0.35),
                  width: 1.r,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Layer (hidden if in overlay-only mode)
            if (!isOverlayOnly)
              _CardBackgroundLayer(
                presetAsset: presetAsset,
                customImageFile: customImageFile,
                videoController: videoController,
              ),

            // 2. High-readability Dark Scrim Overlay (No shadows, subtle gradient)
            if (!isOverlayOnly)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.40),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

            // 3. Foreground Card Content (Surah Badge, Ayah Typography, Reciter & Watermark)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Surah & Ayah Badge
                  _SurahAyahBadge(verse: verse),

                  // Center: Pure Quranic Verse Typography
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          verse.ayahText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            height: 2.1,
                            color: AppColors.pureChalk,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Row: Reciter attribution & Sakina Watermark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reciter tag
                      Flexible(
                        child: _ReciterAttributionBadge(
                          reciterName: reciterName,
                          isPlaying: isPlayingRecitation,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Sakina Watermark
                      const VerseCardWatermark(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBackgroundLayer extends StatelessWidget {
  final String? presetAsset;
  final File? customImageFile;
  final VideoPlayerController? videoController;

  const _CardBackgroundLayer({
    this.presetAsset,
    this.customImageFile,
    this.videoController,
  });

  @override
  Widget build(BuildContext context) {
    if (videoController != null && videoController!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: videoController!.value.size.width,
          height: videoController!.value.size.height,
          child: VideoPlayer(videoController!),
        ),
      );
    }

    if (customImageFile != null) {
      return Image.file(
        customImageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final assetPath = presetAsset ?? 'assets/images/background_1.jpg';
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class _SurahAyahBadge extends StatelessWidget {
  final VerseCardItem verse;

  const _SurahAyahBadge({required this.verse});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.accentGold.withValues(alpha: 0.45),
          width: 0.8.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterIslamicIcons.quran2,
            size: 14.r,
            color: colors.accentGold,
          ),
          SizedBox(width: 8.w),
          Text(
            'سُورَةُ ${verse.surahName} • الآيَةُ ${verse.ayahNumber}',
            style: GoogleFonts.cairo(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: colors.accentGold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReciterAttributionBadge extends StatelessWidget {
  final String reciterName;
  final bool isPlaying;

  const _ReciterAttributionBadge({
    required this.reciterName,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.5),
          width: 0.7.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlaying ? Icons.volume_up_rounded : Icons.mic_none_rounded,
            size: 12.r,
            color: isPlaying ? colors.accentGold : colors.textSecondary,
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              reciterName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
