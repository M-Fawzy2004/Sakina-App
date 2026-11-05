import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Full-screen CapCut-style video export dialog.
/// Displays live progress percentage, animated status steps,
/// a prominent active screen warning notice, and completion actions.
class VerseCardExportDialog extends StatefulWidget {
  final Future<void> Function(
    void Function(double progress, String step) updateProgress,
  ) exportTask;
  final VoidCallback onShare;

  const VerseCardExportDialog({
    super.key,
    required this.exportTask,
    required this.onShare,
  });

  static Future<void> show({
    required BuildContext context,
    required Future<void> Function(
      void Function(double progress, String step) updateProgress,
    ) exportTask,
    required VoidCallback onShare,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return VerseCardExportDialog(
          exportTask: exportTask,
          onShare: onShare,
        );
      },
    );
  }

  @override
  State<VerseCardExportDialog> createState() => _VerseCardExportDialogState();
}

class _VerseCardExportDialogState extends State<VerseCardExportDialog> {
  double _progress = 0.05;
  String _currentStep = 'جَارٍ تَجْهِيزُ مَلَفَّاتِ التَّصْدِيرِ...';
  bool _isFinished = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startExport();
  }

  Future<void> _startExport() async {
    try {
      await widget.exportTask((progress, step) {
        if (mounted) {
          setState(() {
            _progress = progress.clamp(0.0, 1.0);
            _currentStep = step;
            if (_progress >= 1.0) {
              _isFinished = true;
            }
          });
        }
      });
      if (mounted && !_isFinished) {
        setState(() {
          _progress = 1.0;
          _isFinished = true;
          _currentStep = 'اكْتَمَلَ إِنْتَاجُ الرِّيلْز القُرْآنِيّ بِنَجَاحٍ! ✨';
        });
        HapticService.heavyImpact();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'تَعَذَّرَ تَصْدِيرُ الفِيدْيُو، يُرْجَى إِعَادَةُ المُحَاوَلَةِ';
        });
        HapticService.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: _isFinished || _hasError,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 22.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.35),
                  width: 1.r,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Text(
                    _isFinished
                      ? 'تَمَّ التَّصْدِيرُ بِنَجَاح'
                      : (_hasError ? 'فَشَلَ التَّصْدِير' : 'جَارٍ تَصْدِيرُ الرِّيلْز'),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.accentGold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'دِقَّة 1080p • تِلَاوَةٌ عَطِرَة • مُوَاءَمَةُ الآيَات',
                    style: GoogleFonts.cairo(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Circular Progress Indicator & Percentage
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140.r,
                        height: 140.r,
                        child: CircularProgressIndicator(
                          value: _isFinished
                              ? 1.0
                              : (_hasError ? 0.0 : _progress),
                          strokeWidth: 8.r,
                          backgroundColor:
                              colors.accentGold.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _hasError ? Colors.redAccent : colors.accentGold,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isFinished)
                            Icon(
                              Iconsax.tick_circle,
                              size: 54.r,
                              color: colors.accentGold,
                            )
                          else if (_hasError)
                            Icon(
                              Iconsax.close_circle,
                              size: 54.r,
                              color: Colors.redAccent,
                            )
                          else ...[
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: GoogleFonts.cairo(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w900,
                                color: colors.accentGold,
                              ),
                            ),
                            Text(
                              'جَارٍ المَوْنَتَاج',
                              style: GoogleFonts.cairo(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),

                  // Step description
                  Text(
                    _hasError
                        ? (_errorMessage ?? 'حدث خطأ أثناء تصدير الفيديو')
                        : _currentStep,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _hasError ? Colors.redAccent : colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // CapCut Screen Active Warning Banner (shown while exporting)
                  if (!_isFinished && !_hasError)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.45),
                          width: 0.8.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              '⚠️ يُرْجَى إِبْقَاءُ الشَّاشَةِ نَشِطَةً وَعَدَمُ إِغْلَاقِ التَّطْبِيقِ حَتَّى اكْتِمَالِ التَّصْدِيرِ',
                              style: GoogleFonts.cairo(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber[200] ?? Colors.amber,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Actions when finished or error
                  if (_isFinished) ...[
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.accentGold,
                              foregroundColor: colors.background,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: () {
                              HapticService.selectionClick();
                              widget.onShare();
                            },
                            icon: Icon(
                              Iconsax.share,
                              size: 16.r,
                              color: colors.background,
                            ),
                            label: Text(
                              'مُشَارَكَةُ الفِيدْيُو',
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.background,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.accentGold,
                              side: BorderSide(
                                color: colors.accentGold.withValues(alpha: 0.6),
                                width: 1.r,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: () {
                              HapticService.selectionClick();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'تَمَّ الحِفْظُ فِي المَعْرِضِ',
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.accentGold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (_hasError) ...[
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accentGold,
                        foregroundColor: colors.background,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 12.h),
                      ),
                      onPressed: () {
                        HapticService.selectionClick();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'إِغْلَاق',
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.background,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
