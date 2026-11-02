import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_settings_shared.dart';

/// Comfort settings & Auto-Scroll recitation toggles.
class ComfortSettingsSection extends StatelessWidget {
  final QuranReaderPreferences preferences;
  final ValueChanged<QuranReaderPreferences> onPreferencesChanged;

  const ComfortSettingsSection({
    super.key,
    required this.preferences,
    required this.onPreferencesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = preferences.theme;
    final accent = activeTheme.accentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReaderSectionTitle(
          icon: Iconsax.eye,
          title: 'خِيَارَاتُ الرَّاحَةِ البَصَرِيَّةِ',
          accentColor: accent,
        ),
        AppSpacing.verticalXs,

        // 1. Show / Hide verse dividers (only in line-by-line mode)
        _PreferenceSwitchTile(
          icon: Iconsax.eye,
          title: 'إِظْهَارُ فَوَاصِلِ الآيَاتِ المُذَهَّبَةِ',
          subtitle: 'خُطُوطٌ هَامِشِيَّةٌ رَقِيقَةٌ بَيْنَ الآيَاتِ',
          value: preferences.showDividers,
          accentColor: accent,
          activeTheme: activeTheme,
          onChanged: (val) {
            HapticService.selectionClick();
            onPreferencesChanged(preferences.copyWith(showDividers: val));
          },
        ),

        AppSpacing.verticalXs,

        // 2. Keep screen awake toggle
        _PreferenceSwitchTile(
          icon: Iconsax.lamp_on,
          title: 'إِبْقَاءُ الشَّاشَةِ مُضَاءَةً',
          subtitle: 'مَنْعُ انْطِفَاءِ الشَّاشَةِ أَثْنَاءَ التِّلَاوَةِ',
          value: preferences.isKeepScreenAwake,
          accentColor: accent,
          activeTheme: activeTheme,
          onChanged: (val) {
            HapticService.selectionClick();
            onPreferencesChanged(preferences.copyWith(isKeepScreenAwake: val));
          },
        ),

        AppSpacing.verticalXs,

        // 3. Hands-free Auto-Scroll toggle
        _PreferenceSwitchTile(
          icon: Iconsax.play_circle,
          title: 'التَّمْرِيرُ التِّلْقَائِيُّ الذَّكِيُّ',
          subtitle: 'تَمْرِيرٌ انْسِيَابِيٌّ لِلآيَاتِ بِلَا لَمْسِ الشَّاشَةِ',
          value: preferences.isAutoScrollEnabled,
          accentColor: accent,
          activeTheme: activeTheme,
          onChanged: (val) {
            HapticService.selectionClick();
            onPreferencesChanged(preferences.copyWith(isAutoScrollEnabled: val));
          },
        ),
      ],
    );
  }
}

/// Platform-adaptive switch tile adapting natively to iOS Cupertino & Android Material
class _PreferenceSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<bool> onChanged;

  const _PreferenceSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accentColor,
    required this.activeTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: activeTheme.itemBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: activeTheme.borderColor.withValues(alpha: 0.3),
              width: 0.8.r,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20.r, color: accentColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: activeTheme.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5.sp,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: activeTheme.secondaryTextColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                activeThumbColor: accentColor,
                activeTrackColor: accentColor.withValues(alpha: 0.45),
                inactiveThumbColor: activeTheme.secondaryTextColor,
                inactiveTrackColor: activeTheme.cardColor,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

