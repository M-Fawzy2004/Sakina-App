import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Reciter Profile Hero Card with Avatar Medallion, Riwayah tags, and Play/Shuffle actions.
class ReciterProfileHeroCard extends StatelessWidget {
  final ReciterEntity reciter;
  final VoidCallback onPlayFirstTrack;
  final VoidCallback onShufflePlay;

  const ReciterProfileHeroCard({
    super.key,
    required this.reciter,
    required this.onPlayFirstTrack,
    required this.onShufflePlay,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: AppSpacing.radiusLg,
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Ornate Avatar Medallion with Avatar Letter
                ReciterAvatarMedallion(
                  photoUrl: reciter.photoUrl,
                  nameArabic: reciter.nameArabic,
                  avatarLetter: reciter.avatarLetter,
                  size: 64,
                  isGlowing: true,
                ),
                SizedBox(width: 14.w),

                // Reciter Sacred Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reciter.nameArabic,
                        style: GoogleFonts.cairo(
                          fontSize: 16.5.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        reciter.revelationStyle,
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.accentGold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: colors.borderHairline.withValues(alpha: 0.5),
                                width: 0.8.r,
                              ),
                            ),
                            child: Text(
                              reciter.riwayah,
                              style: GoogleFonts.cairo(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: colors.borderHairline.withValues(alpha: 0.5),
                                width: 0.8.r,
                              ),
                            ),
                            child: Text(
                              '114 سورة كاملة',
                              style: GoogleFonts.cairo(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Action Buttons (Play from beginning / Shuffle)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onPlayFirstTrack();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      decoration: BoxDecoration(
                        color: colors.accentGold,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.play5,
                            size: 16.r,
                            color: colors.background,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'بدء من الفاتحة',
                              style: GoogleFonts.cairo(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.background,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onShufflePlay();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: colors.borderHairline.withValues(alpha: 0.7),
                          width: 1.r,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.shuffle,
                            size: 16.r,
                            color: colors.textPrimary,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'تشغيل عشوائي',
                              style: GoogleFonts.cairo(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

