import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// "Tafsir & Reflections / التفسير والتدبر" Modal Card matching Screen 3 in the mockup:
/// Displays active verse text in emerald highlight capsule,
/// audio waveform player, authentic Tafsir & reflection body, and share action.
class QuranTafsirReflectionSheet extends StatefulWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final VoidCallback onClose;

  const QuranTafsirReflectionSheet({
    super.key,
    required this.surah,
    required this.ayah,
    required this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required SurahEntity surah,
    required AyahEntity ayah,
  }) {
    HapticService.lightImpact();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (modalContext) => QuranTafsirReflectionSheet(
        surah: surah,
        ayah: ayah,
        onClose: () => Navigator.of(modalContext).pop(),
      ),
    );
  }

  @override
  State<QuranTafsirReflectionSheet> createState() => _QuranTafsirReflectionSheetState();
}

class _QuranTafsirReflectionSheetState extends State<QuranTafsirReflectionSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleAudio() {
    HapticService.lightImpact();
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
      if (_isPlayingAudio) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
      }
    });
  }

  void _shareAyah(BuildContext context) {
    HapticService.selectionClick();
    final shareText = '«${widget.ayah.text}»\n'
        'سورة ${widget.surah.nameArabic} - الآية ${widget.ayah.numberInSurah}\n\n'
        'التفسير: ${widget.ayah.tafsir ?? ""}\n'
        'التدبر: ${widget.ayah.reflection ?? ""}';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.carbonSlate,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.emeraldGlow, width: 1.r),
        ),
        content: Text(
          'تم نسخ نص الآية والتفسير للمشاركة بنجاح ✓',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.emeraldGlow,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tafsirText = widget.ayah.tafsir ??
        'الآية الكريمة تتضمن بياناً شاملاً من آيات الذكر الحكيم، تزيد القلب إيماناً ورسوخاً.';
    final reflectionText = widget.ayah.reflection ??
        'تدبر هذه الآية يورث الطمأنينة والانقياد لأمر الله والعمل بمقتضى كلامه.';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.obsidianCore,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 1.r,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Drag Handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.mutedSilver.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            AppSpacing.verticalSm,

            // 2. Surah & Ayah Title Bar + Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.champagneGold,
                          width: 1.r,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.ayah.numberInSurah}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.champagneGold,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سُورَةُ ${widget.surah.nameArabic}',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.pureChalk,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                        ),
                        Text(
                          'الآية ${widget.ayah.numberInSurah} • ص ${widget.ayah.page}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.champagneGold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.mutedSilver,
                    size: 20.r,
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSm,

            // 3. Active Highlighted Verse Pill (matching Screen 3 in mockup)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.emeraldGlow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.emeraldGlow,
                  width: 1.2.r,
                ),
              ),
              child: Text(
                '«${widget.ayah.text}»',
                textAlign: TextAlign.center,
                style: AppTextStyles.quranAyah.copyWith(
                  color: AppColors.pureChalk,
                  fontSize: 19.sp,
                  height: 2.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            AppSpacing.verticalSm,

            // 4. Audio Waveform & Glowing Emerald Play/Pause Button (matching Screen 3)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  // Emerald Play/Pause Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleAudio,
                      customBorder: const CircleBorder(),
                      splashColor: AppColors.emeraldGlow.withValues(alpha: 0.2),
                      child: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: const BoxDecoration(
                          color: AppColors.emeraldGlow,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            _isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: AppColors.obsidianCore,
                            size: 26.r,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Animated Waveform Bars
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(24, (i) {
                            final factor = _isPlayingAudio
                                ? (0.2 + 0.8 * (0.5 + 0.5 * ((i * 0.4) + _waveController.value * 6.28).abs() % 1.0))
                                : 0.25;
                            final isGold = i % 2 == 0;
                            return Container(
                              width: 3.w,
                              height: (28.h * factor).clamp(6.h, 28.h),
                              decoration: BoxDecoration(
                                color: isGold ? AppColors.champagneGold : AppColors.emeraldGlow,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSm,

            // 5. "Tafsir & Reflections / التفسير والتدبر" Card (matching Screen 3)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 1.r,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: "Tafsir & Reflections • التَّفْسِيرُ وَالتَّدَبُّرُ"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tafsir & Reflections • التَّفْسِيرُ وَالتَّدَبُّرُ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.champagneGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedBookOpen01,
                        color: AppColors.champagneGold,
                        size: 16.r,
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Tafsir Body Text
                  Text(
                    tafsirText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.pureChalk,
                      fontSize: 13.5.sp,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Spiritual Reflection Body
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.carbonSlate,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.goldBorderStroke,
                        width: 0.8.r,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 ', style: AppTextStyles.caption.copyWith(fontSize: 13.sp)),
                        Expanded(
                          child: Text(
                            reflectionText,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.paleRadiance,
                              fontSize: 11.5.sp,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Share Button & Page Reference
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Share Button
                      TextButton.icon(
                        onPressed: () => _shareAyah(context),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedShare01,
                          color: AppColors.champagneGold,
                          size: 16.r,
                        ),
                        label: Text(
                          'Share • مُشَارَكَة',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.champagneGold,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                      // Bottom Page & Juz Footer (matching Screen 3: "الجزء 29 • ص 562")
                      Text(
                        'الجُزْءُ ${widget.ayah.juz} • ص ${widget.ayah.page}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.mutedSilver,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
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
