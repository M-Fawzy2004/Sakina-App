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
  final GlobalKey? overlayKey;
  final VerseCardItem verse;
  final String? presetAsset;
  final File? customImageFile;
  final VideoPlayerController? videoController;
  final String reciterName;
  final bool isPlayingRecitation;
  final bool isOverlayOnly;
  final VoidCallback? onBadgeTap;
  final int currentAyahDisplayIndex;

  const VerseCardDisplay({
    super.key,
    required this.cardKey,
    this.overlayKey,
    required this.verse,
    this.presetAsset,
    this.customImageFile,
    this.videoController,
    required this.reciterName,
    required this.isPlayingRecitation,
    this.isOverlayOnly = false,
    this.onBadgeTap,
    this.currentAyahDisplayIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final hasMultiVerses =
        verse.versesTextList != null && verse.versesTextList!.isNotEmpty;
    final activeAyahText = hasMultiVerses
        ? verse.getAyahTextAt(currentAyahDisplayIndex)
        : verse.ayahText;
    final activeAyahNumber = verse.ayahNumber + currentAyahDisplayIndex;

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isOverlayOnly ? Colors.transparent : AppColors.obsidianCore,
          borderRadius:
              isOverlayOnly ? BorderRadius.zero : BorderRadius.circular(16.r),
          border: null,
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

            // 3. Foreground Card Content (Surah Badge, Animated Ayah Typography, Reciter & Watermark)
            // Wrapped in overlayKey boundary so it can be captured as a pure transparent
            // overlay with zero video/background freeze for video reel compilation.
            RepaintBoundary(
              key: overlayKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Surah & Active Ayah Badge
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onBadgeTap,
                      child: _SurahAyahBadge(
                        surahName: verse.surahName,
                        ayahNumber: activeAyahNumber,
                      ),
                    ),

                    // Center: Pure Quranic Verse Typography
                    // When in isOverlayOnly mode (capturing static PNG frames for video),
                    // render direct Text without AnimatedSwitcher to prevent cross-frame ghosting.
                    Expanded(
                      child: Center(
                        child: isOverlayOnly
                            ? SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Text(
                                  activeAyahText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.amiri(
                                    fontSize: activeAyahText.length > 250
                                        ? 14.5.sp
                                        : (activeAyahText.length > 150
                                            ? 17.5.sp
                                            : 21.sp),
                                    fontWeight: FontWeight.w700,
                                    height:
                                        activeAyahText.length > 250 ? 1.85 : 2.1,
                                    color: AppColors.pureChalk,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.85),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 550),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.05),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: SingleChildScrollView(
                                  key: ValueKey('$activeAyahNumber-$activeAyahText'),
                                  physics: const BouncingScrollPhysics(),
                                  child: Text(
                                    activeAyahText,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.amiri(
                                      fontSize: activeAyahText.length > 250
                                          ? 14.5.sp
                                          : (activeAyahText.length > 150
                                              ? 17.5.sp
                                              : 21.sp),
                                      fontWeight: FontWeight.w700,
                                      height:
                                          activeAyahText.length > 250 ? 1.85 : 2.1,
                                      color: AppColors.pureChalk,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.85),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // Bottom Row: Reciter attribution & Sakina Watermark
                    // Reciter badge is hidden for static images, shown only for video reels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (videoController != null)
                          Flexible(
                            child: _ReciterAttributionBadge(
                              reciterName: reciterName,
                              isPlaying: isPlayingRecitation,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        SizedBox(width: 8.w),

                        // Sakina Watermark
                        const VerseCardWatermark(),
                      ],
                    ),
                  ],
                ),
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
  final String surahName;
  final int ayahNumber;

  const _SurahAyahBadge({
    required this.surahName,
    required this.ayahNumber,
  });

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
            'سُورَةُ $surahName • الآيَةُ $ayahNumber',
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPlaying ? Icons.volume_up_rounded : Icons.mic_none_rounded,
            size: 13.r,
            color: isPlaying
                ? colors.accentGold
                : AppColors.pureChalk.withValues(alpha: 0.8),
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              reciterName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.pureChalk.withValues(alpha: 0.85),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
