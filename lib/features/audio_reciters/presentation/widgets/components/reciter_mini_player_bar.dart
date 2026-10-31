import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Floating mini player ribbon shown when a track is actively playing or paused.
class ReciterMiniPlayerBar extends StatelessWidget {
  final RecitationTrackEntity track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlayPauseTap;

  const ReciterMiniPlayerBar({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
    required this.onPlayPauseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppSpacing.radiusMd,
            border: Border.all(
              color: AppColors.champagneGold,
              width: 1.2.r,
            ),
          ),
          child: Row(
            children: [
              ReciterAvatarMedallion(
                nameArabic: track.reciterName,
                size: 40,
                isGlowing: isPlaying,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      track.surahNameArabic,
                      style: GoogleFonts.amiri(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pureChalk,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.reciterName,
                      style: GoogleFonts.cairo(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.champagneGold,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onPlayPauseTap,
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagneGold,
                    border: Border.all(
                      color: AppColors.obsidianCore,
                      width: 1.r,
                    ),
                  ),
                  child: Icon(
                    isPlaying ? Iconsax.pause : Iconsax.play,
                    color: AppColors.obsidianCore,
                    size: 18.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
