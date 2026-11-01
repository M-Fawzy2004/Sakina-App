import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Professional Live Broadcast Status Bar that replaces the track progress scrubber bar.
/// Completely eliminates seconds counters and progress sliders for 24/7 live sanctuary feeds.
class LiveBroadcastStatusBar extends StatefulWidget {
  final bool isPlaying;

  const LiveBroadcastStatusBar({
    super.key,
    required this.isPlaying,
  });

  @override
  State<LiveBroadcastStatusBar> createState() => _LiveBroadcastStatusBarState();
}

class _LiveBroadcastStatusBarState extends State<LiveBroadcastStatusBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _beaconController;

  @override
  void initState() {
    super.initState();
    _beaconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.isPlaying) {
      _beaconController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant LiveBroadcastStatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _beaconController.repeat(reverse: true);
      } else {
        _beaconController.stop();
      }
    }
  }

  @override
  void dispose() {
    _beaconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Right: Animated Pulsing Live Indicator (مباشر LIVE)
          AnimatedBuilder(
            animation: _beaconController,
            builder: (context, _) {
              final opacity = widget.isPlaying
                  ? 0.45 + (0.55 * _beaconController.value)
                  : 0.5;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.errorRed.withValues(alpha: opacity),
                    width: 1.r,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.errorRed.withValues(alpha: opacity),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'مباشر LIVE',
                      style: GoogleFonts.cairo(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.errorRed,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Center: Continuous transmission description
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'نقل حي عبر الأقمار الاصطناعية • 24 ساعة',
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 3. Left: Stream Quality & Signal Stability Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.emeraldGlow.withValues(alpha: 0.25),
                width: 1.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emeraldGlow,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  '320kbps HD',
                  style: GoogleFonts.cairo(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emeraldGlow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

