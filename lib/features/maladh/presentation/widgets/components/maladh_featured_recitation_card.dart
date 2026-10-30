import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_audio_waveform.dart';

/// "تلاوة اللحظة المختارة" - Featured spiritual recitation card
/// presenting a rare, moving verse with Sheikh Abdulbasit Abdussamad,
/// an audio waveform visualizer, and crisp solid emerald playback controls without shadows.
class MaladhFeaturedRecitationCard extends StatefulWidget {
  final VoidCallback? onPlayPauseTap;

  const MaladhFeaturedRecitationCard({
    super.key,
    this.onPlayPauseTap,
  });

  @override
  State<MaladhFeaturedRecitationCard> createState() =>
      _MaladhFeaturedRecitationCardState();
}

class _MaladhFeaturedRecitationCardState
    extends State<MaladhFeaturedRecitationCard> {
  bool _isPlaying = true;

  void _togglePlayback() {
    HapticService.selectionClick();
    setState(() {
      _isPlaying = !_isPlaying;
    });
    widget.onPlayPauseTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Bar: "تلاوة اللحظة المختارة" & "نادرة ومؤثرة" Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right Side: Crisp Solid Emerald Dot + Title (RTL Start)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldGlow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'تِلَاوَةُ اللَّحْظَةِ المُخْتَارَةِ',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.pureChalk,
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Left Side: Emerald Pill Tag "نادرة ومؤثرة" (RTL End)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0x2210B981),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0x5510B981),
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    'نَادِرَةٌ وَمُؤَثِّرَةٌ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.emeraldGlow,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSm,

            // 2. Inner Sacred Verse Slab
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.carbonSlate,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 1.r,
                ),
              ),
              child: Column(
                children: [
                  // Quranic Verse Centered
                  Text(
                    '«وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ»',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.quranAyah.copyWith(
                      fontSize: 18.sp,
                      height: 1.8,
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Citation: Surah, Ayah, and Reciter
                  Text(
                    'سُورَةُ البَقَرَةِ • الآيَة 186 • بِصَوْتِ الشَّيْخِ عَبْدِ البَاسِطِ عَبْدِ الصَّمَدِ',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedSilver,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSm,

            // 3. Audio Waveform Visualizer
            MaladhAudioWaveform(isPlaying: _isPlaying),

            SizedBox(height: 14.h),

            // 4. Playback Controls & Timestamps Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Right Time: Elapsed Progress (RTL Start)
                Text(
                  '04:18',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedSilver,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Center: Clean Solid Emerald Play/Pause Circular Button (No shadow)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _togglePlayback,
                    customBorder: const CircleBorder(),
                    splashColor: AppColors.goldGlowSoft,
                    child: Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldGlow,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.obsidianCore,
                          size: 28.r,
                        ),
                      ),
                    ),
                  ),
                ),

                // Left Time: Total Track Duration (RTL End)
                Text(
                  '07:30',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedSilver,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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
