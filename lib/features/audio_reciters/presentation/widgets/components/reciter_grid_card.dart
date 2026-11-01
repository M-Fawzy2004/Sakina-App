import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Dark Luxury 2-Column Grid Card for curated Quran Reciters.
/// Zero drop-shadows with tactile border illumination and centered medallion avatar.
class ReciterGridCard extends StatelessWidget {
  final ReciterEntity reciter;
  final bool isCurrentPlaying;
  final VoidCallback onTap;

  const ReciterGridCard({
    super.key,
    required this.reciter,
    required this.isCurrentPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isCurrentPlaying ? colors.surfaceElevated : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isCurrentPlaying
                  ? colors.accentGold
                  : colors.borderHairline.withValues(alpha: 0.65),
              width: isCurrentPlaying ? 1.5.r : 1.r,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Medallion Avatar with Calligraphic Initial Letter
              ReciterAvatarMedallion(
                photoUrl: reciter.photoUrl,
                nameArabic: reciter.nameArabic,
                avatarLetter: reciter.avatarLetter,
                size: 52,
                isGlowing: isCurrentPlaying,
              ),
              SizedBox(height: 8.h),

              // Reciter Name
              Text(
                reciter.nameArabic,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isCurrentPlaying ? colors.accentGold : colors.textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 3.h),

              // Spiritual Title / Epithet
              Text(
                reciter.revelationStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.accentGold.withValues(alpha: 0.9),
                  height: 1.2,
                ),
              ),
              SizedBox(height: 7.h),

              // Bottom Riwayah & Surahs Capsule
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isCurrentPlaying
                        ? colors.accentGold.withValues(alpha: 0.6)
                        : colors.borderHairline.withValues(alpha: 0.5),
                    width: 0.8.r,
                  ),
                ),
                child: Text(
                  isCurrentPlaying ? 'يُتلى الآن 🔊' : '${reciter.riwayah} • 114 سورة',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isCurrentPlaying ? colors.accentGold : colors.textSecondary,
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

