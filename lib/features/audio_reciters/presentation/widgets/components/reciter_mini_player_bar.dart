import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Floating mini player ribbon with interactive downward drag-to-dismiss gesture.
/// Supports swiping down to instantly stop and dismiss the active or paused recitation.
class ReciterMiniPlayerBar extends StatefulWidget {
  final RecitationTrackEntity track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback? onDismiss;

  const ReciterMiniPlayerBar({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
    required this.onPlayPauseTap,
    this.onDismiss,
  });

  @override
  State<ReciterMiniPlayerBar> createState() => _ReciterMiniPlayerBarState();
}

class _ReciterMiniPlayerBarState extends State<ReciterMiniPlayerBar> {
  double _dragOffsetY = 0.0;
  bool _isDismissing = false;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isDismissing) return;
    if (details.primaryDelta != null && details.primaryDelta! > 0) {
      setState(() {
        _dragOffsetY = (_dragOffsetY + details.primaryDelta!).clamp(0.0, 100.0);
      });
    } else if (details.primaryDelta != null && details.primaryDelta! < 0 && _dragOffsetY > 0) {
      setState(() {
        _dragOffsetY = (_dragOffsetY + details.primaryDelta!).clamp(0.0, 100.0);
      });
    }
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_isDismissing) return;
    final velocity = details.primaryVelocity ?? 0.0;

    // Trigger dismiss if dragged down sufficiently or swiped down with momentum
    if (_dragOffsetY > 24.0 || velocity > 220.0) {
      _triggerDismiss();
    } else {
      // Rebound back smoothly
      setState(() {
        _dragOffsetY = 0.0;
      });
    }
  }

  void _triggerDismiss() {
    if (_isDismissing) return;
    setState(() {
      _isDismissing = true;
      _dragOffsetY = 90.0;
    });
    HapticService.mediumImpact();
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Transform.translate(
        offset: Offset(0, _dragOffsetY),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _isDismissing ? 0.0 : (1.0 - (_dragOffsetY / 100.0)).clamp(0.0, 1.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onVerticalDragUpdate: _handleVerticalDragUpdate,
            onVerticalDragEnd: _handleVerticalDragEnd,
            child: Container(
              padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 8.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: AppSpacing.radiusMd,
                border: Border.all(
                  color: colors.accentGold,
                  width: 1.2.r,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subtle drag-down dismiss handle bar
                  Container(
                    width: 32.w,
                    height: 3.5.h,
                    margin: EdgeInsets.only(bottom: 6.h),
                    decoration: BoxDecoration(
                      color: colors.textSecondary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  Row(
                    children: [
                      // Reciter / Sanctuary Avatar Medallion
                      ReciterAvatarMedallion(
                        nameArabic: widget.track.reciterName,
                        size: 40,
                        isGlowing: widget.isPlaying,
                      ),
                      SizedBox(width: 12.w),

                      // Track & Reciter Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.track.surahNameArabic,
                              style: GoogleFonts.amiri(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.track.reciterName,
                              style: GoogleFonts.cairo(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.accentGold,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Quick Close / Dismiss Icon
                      GestureDetector(
                        onTap: _triggerDismiss,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          margin: EdgeInsets.only(left: 6.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.surfaceElevated,
                            border: Border.all(
                              color: colors.borderHairline,
                              width: 1.r,
                            ),
                          ),
                          child: Icon(
                            Iconsax.close_circle,
                            color: colors.textSecondary,
                            size: 16.r,
                          ),
                        ),
                      ),

                      // Play/Pause circular button
                      GestureDetector(
                        onTap: () {
                          HapticService.lightImpact();
                          widget.onPlayPauseTap();
                        },
                        child: Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.accentGold,
                            border: Border.all(
                              color: colors.background,
                              width: 1.r,
                            ),
                          ),
                          child: Icon(
                            widget.isPlaying ? Iconsax.pause : Iconsax.play,
                            color: colors.background,
                            size: 18.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
