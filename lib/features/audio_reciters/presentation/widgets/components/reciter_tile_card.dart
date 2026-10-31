import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Reciter list item card matching the catalog list in the design mockup.
class ReciterTileCard extends StatelessWidget {
  final ReciterEntity reciter;
  final bool isCurrentPlaying;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const ReciterTileCard({
    super.key,
    required this.reciter,
    required this.isCurrentPlaying,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.radiusMd,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isCurrentPlaying ? AppColors.surfaceElevated : AppColors.carbonSlate,
              borderRadius: AppSpacing.radiusMd,
              border: Border.all(
                color: isCurrentPlaying ? AppColors.champagneGold : AppColors.goldBorderStroke,
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                // Medallion Avatar with Golden Rim
                ReciterAvatarMedallion(
                  photoUrl: reciter.photoUrl,
                  nameArabic: reciter.nameArabic,
                  size: 52,
                  isGlowing: isCurrentPlaying,
                ),
                SizedBox(width: 12.w),

                // Reciter Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              reciter.nameArabic,
                              style: GoogleFonts.cairo(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w700,
                                color: isCurrentPlaying ? AppColors.champagneGold : AppColors.pureChalk,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentPlaying) ...[
                            SizedBox(width: 6.w),
                            const _PlayingMiniPulsar(),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(
                            Iconsax.eye,
                            size: 13.r,
                            color: AppColors.champagneGold,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            reciter.formattedListeners,
                            style: GoogleFonts.cairo(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedSilver,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.mutedSilver,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              reciter.riwayah,
                              style: GoogleFonts.cairo(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mutedSilver,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Trailing Action Button
                GestureDetector(
                  onTap: onActionTap,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentPlaying ? AppColors.champagneGold : AppColors.frostedGlass,
                      border: Border.all(
                        color: isCurrentPlaying ? AppColors.champagneGold : AppColors.goldBorderStroke,
                        width: 1.r,
                      ),
                    ),
                    child: Icon(
                      isCurrentPlaying ? Iconsax.pause : Iconsax.arrow_left_2,
                      color: isCurrentPlaying ? AppColors.obsidianCore : AppColors.champagneGold,
                      size: 16.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayingMiniPulsar extends StatelessWidget {
  const _PlayingMiniPulsar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 2.5.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: AppColors.emeraldGlow,
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
        SizedBox(width: 1.5.w),
        Container(
          width: 2.5.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.champagneGold,
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
        SizedBox(width: 1.5.w),
        Container(
          width: 2.5.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.paleRadiance,
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
      ],
    );
  }
}
