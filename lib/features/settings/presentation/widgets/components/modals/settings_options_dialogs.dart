import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Modal dialogs for settings choices: Audio Quality, Sleep Timer, Reading Style, and Clear Cache.
abstract final class SettingsOptionsDialogs {
  /// Opens dialog to choose audio streaming quality.
  static Future<String?> showAudioQualityDialog(
    BuildContext context,
    String currentQuality,
  ) {
    HapticService.selectionClick();
    final colors = context.colors;
    final options = [
      'جَوْدَةٌ عَالِيَةٌ (HQ 128 kbps) — نَقَاءُ اسْتُودْيُو',
      'مُوَفِّرُ البَيَانَاتِ (Data Saver 64 kbps)',
    ];

    return showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: _RadioOptionDialog(
          title: 'جَوْدَةُ البَثِّ الصَّوْتِيِّ',
          icon: Iconsax.music_dashboard,
          options: options,
          selectedOption: currentQuality,
          colors: colors,
        ),
      ),
    );
  }

  /// Opens dialog to configure audio sleep timer.
  static Future<String?> showSleepTimerDialog(
    BuildContext context,
    String currentTimer,
  ) {
    HapticService.selectionClick();
    final colors = context.colors;
    final options = [
      'مُعَطَّلٌ حَالِيًّا',
      '١٥ دَقِيقَةً',
      '٣٠ دَقِيقَةً',
      '٤٥ دَقِيقَةً',
      '٦٠ دَقِيقَةً (سَاعَةٌ كَامِلَةٌ)',
    ];

    return showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: _RadioOptionDialog(
          title: 'مُؤَقِّتُ النَّوْمِ التِّلْقَائِيُّ',
          icon: Iconsax.timer_1,
          options: options,
          selectedOption: currentTimer,
          colors: colors,
        ),
      ),
    );
  }

  /// Opens dialog to choose Quran reading style mode.
  static Future<String?> showReadingStyleDialog(
    BuildContext context,
    String currentStyle,
  ) {
    HapticService.selectionClick();
    final colors = context.colors;
    final options = [
      'كُرُوتُ الآيَاتِ المُنْفَرِدَةِ مَعَ إِضَاءَةِ التِّلَاوَةِ',
      'المُصْحَفُ المَتَتَابِعُ (صَفَحَاتٌ مُتَّصِلَةٌ)',
    ];

    return showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: _RadioOptionDialog(
          title: 'نَمَطُ عَرْضِ القِرَاءَةِ',
          icon: Iconsax.document_text,
          options: options,
          selectedOption: currentStyle,
          colors: colors,
        ),
      ),
    );
  }

  /// Opens dialog to confirm clearing cached content files.
  static Future<bool?> showClearCacheDialog(
    BuildContext context,
    String cacheSizeText,
  ) {
    HapticService.selectionClick();
    final colors = context.colors;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: colors.borderHairline.withValues(alpha: 0.8),
              width: 1.r,
            ),
          ),
          title: Row(
            children: [
              Icon(Iconsax.trash, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'مَسْحُ الذَّاكِرَةِ المُؤَقَّتَةِ',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الحجم المستهلك حالياً: $cacheSizeText',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.accentGold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'سيتم تفريغ ملفات الصوت والصفحات المؤقتة لتحرير مساحة جهازك. لن يتم مسح أي إشارات مرجعية أو تقدم في الحفظ والإنابة.',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'إِلْغَاء',
                style: GoogleFonts.cairo(
                  color: colors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'تَفْرِيغُ الآن',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioOptionDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> options;
  final String selectedOption;
  final AppColorsScheme colors;

  const _RadioOptionDialog({
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedOption,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: colors.borderHairline.withValues(alpha: 0.8),
          width: 1.r,
        ),
      ),
      title: Row(
        children: [
          Icon(icon, color: colors.accentGold, size: 20.r),
          SizedBox(width: 8.w),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) {
            final isSelected = selectedOption == opt;
            return Container(
              margin: EdgeInsets.only(bottom: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.12)
                    : colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? colors.accentGold
                      : colors.borderHairline.withValues(alpha: 0.5),
                  width: isSelected ? 1.4.r : 0.8.r,
                ),
              ),
              child: ListTile(
                dense: true,
                onTap: () {
                  HapticService.selectionClick();
                  Navigator.of(context).pop(opt);
                },
                title: Text(
                  opt,
                  style: GoogleFonts.cairo(
                    fontSize: 12.5.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? colors.accentGold : colors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded,
                        color: colors.accentGold, size: 18.r)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
