import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Dark Luxury Reciter Card with zero drop-shadows and tactile feedback.
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
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.selectionClick();
            onTap();
          },
          borderRadius: AppSpacing.radiusLg,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isCurrentPlaying ? colors.surfaceElevated : colors.cardSurface,
              borderRadius: AppSpacing.radiusLg,
              border: Border.all(
                color: isCurrentPlaying
                    ? colors.accentGold
                    : colors.borderHairline.withValues(alpha: 0.65),
                width: isCurrentPlaying ? 1.5.r : 1.r,
              ),
            ),
            child: Row(
              children: [
                // Medallion Avatar with Golden Calligraphic Avatar Letter
                ReciterAvatarMedallion(
                  photoUrl: reciter.photoUrl,
                  nameArabic: reciter.nameArabic,
                  avatarLetter: reciter.avatarLetter,
                  size: 54,
                  isGlowing: isCurrentPlaying,
                ),
                SizedBox(width: 14.w),

                // Reciter Sacred Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sheikh Name + Active Playing Indicator
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              reciter.nameArabic,
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: isCurrentPlaying ? colors.accentGold : colors.textPrimary,
                                height: 1.2,
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
                      SizedBox(height: 4.h),

                      // Sheikh Spiritual Title / Epithet
                      Text(
                        reciter.revelationStyle,
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.accentGold.withValues(alpha: 0.9),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),

                      // Bottom Metadata Capsule Tags
                      Row(
                        children: [
                          // Riwayah Tag
                          _LuxuryMetaPill(
                            icon: Iconsax.book_1,
                            label: reciter.riwayah,
                          ),
                          SizedBox(width: 6.w),

                          // Surahs Count Tag
                          _LuxuryMetaPill(
                            icon: Iconsax.music_dashboard,
                            label: '${reciter.availableSurahsCount} سورة',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // Direct Surahs Action Button
                _SurahsNavigationAction(
                  isCurrentPlaying: isCurrentPlaying,
                  onActionTap: onActionTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LuxuryMetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LuxuryMetaPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.5),
          width: 0.8.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11.r,
            color: colors.accentGold,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahsNavigationAction extends StatelessWidget {
  final bool isCurrentPlaying;
  final VoidCallback onActionTap;

  const _SurahsNavigationAction({
    required this.isCurrentPlaying,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        onActionTap();
      },
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrentPlaying ? colors.accentGold : colors.surfaceElevated,
          border: Border.all(
            color: isCurrentPlaying
                ? colors.accentGold
                : colors.borderHairline.withValues(alpha: 0.6),
            width: 1.r,
          ),
        ),
        child: Icon(
          isCurrentPlaying ? Iconsax.pause : Iconsax.arrow_left_2,
          size: 16.r,
          color: isCurrentPlaying ? colors.background : colors.accentGold,
        ),
      ),
    );
  }
}

class _PlayingMiniPulsar extends StatefulWidget {
  const _PlayingMiniPulsar();

  @override
  State<_PlayingMiniPulsar> createState() => _PlayingMiniPulsarState();
}

class _PlayingMiniPulsarState extends State<_PlayingMiniPulsar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: context.colors.accentGold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: context.colors.accentGold.withValues(alpha: 0.5 + (_controller.value * 0.5)),
              width: 0.8.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.accentGold,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'يُتلى الآن',
                style: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.accentGold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
