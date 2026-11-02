import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_comfort_section.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_settings_shared.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_style_section.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_theme_section.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_typography_section.dart';

/// Luxury bottom sheet for calibrating Quran reader preferences:
/// - Real-time instantaneous state synchronization (both in-sheet and on underlying reader)
/// - Shadow-free luxury tactile dark styling (zero drop shadows)
/// - Platform-adaptive native toggles (`Switch.adaptive` for iOS Cupertino & Android Material)
/// - Discrete 4-step font size calibration with live preview
/// - Reading style switch (Verse-by-verse vs Continuous flowing Mushaf)
/// - Atmospheric ambient themes (Obsidian, Emerald Sanctuary, Sahar Amber)
/// - Line spacing & Tashkeel breathing room
/// - Auto-scroll recitation & screen awake toggles
class QuranReaderSettingsSheet extends StatefulWidget {
  final QuranReaderPreferences preferences;
  final ValueChanged<QuranReaderPreferences> onPreferencesChanged;

  const QuranReaderSettingsSheet({
    super.key,
    required this.preferences,
    required this.onPreferencesChanged,
  });

  @override
  State<QuranReaderSettingsSheet> createState() =>
      _QuranReaderSettingsSheetState();
}

class _QuranReaderSettingsSheetState extends State<QuranReaderSettingsSheet> {
  late QuranReaderPreferences _currentPreferences;

  @override
  void initState() {
    super.initState();
    _currentPreferences = widget.preferences;
  }

  @override
  void didUpdateWidget(covariant QuranReaderSettingsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preferences != oldWidget.preferences) {
      _currentPreferences = widget.preferences;
    }
  }

  void _updatePreferences(QuranReaderPreferences updated) {
    setState(() {
      _currentPreferences = updated;
    });
    widget.onPreferencesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = _currentPreferences.theme;
    final activeAccent = activeTheme.accentColor;

    return Container(
      constraints: BoxConstraints(maxHeight: 680.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: activeTheme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        border: Border.all(
          color: activeAccent.withValues(alpha: 0.6),
          width: 1.2.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ReaderDragHandle(),
          AppSpacing.verticalXs,
          ReaderSheetHeader(
            accentColor: activeAccent,
            secondaryTextColor: activeTheme.secondaryTextColor,
          ),
          AppSpacing.verticalSm,
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. Reading Style (Verse-by-verse vs Continuous)
                ReadingStyleSection(
                  selectedStyle: _currentPreferences.style,
                  accentColor: activeAccent,
                  activeTheme: activeTheme,
                  onStyleChanged: (newStyle) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(style: newStyle),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 2. Quranic Calligraphy Script Style
                ScriptStyleSection(
                  selectedScriptStyle: _currentPreferences.scriptStyle,
                  accentColor: activeAccent,
                  activeTheme: activeTheme,
                  onScriptStyleChanged: (newScript) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(scriptStyle: newScript),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 3. Font Size (4 discrete sizes + Live Preview)
                FontSizeSection(
                  selectedSize: _currentPreferences.fontSize,
                  scriptStyle: _currentPreferences.scriptStyle,
                  accentColor: activeAccent,
                  activeTheme: activeTheme,
                  lineSpacing: _currentPreferences.lineSpacing,
                  onSizeChanged: (newSize) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(fontSize: newSize),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 4. Ambient Reading Themes
                ThemesSection(
                  selectedTheme: _currentPreferences.theme,
                  onThemeChanged: (newTheme) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(theme: newTheme),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 5. Line Spacing
                LineSpacingSection(
                  selectedSpacing: _currentPreferences.lineSpacing,
                  accentColor: activeAccent,
                  activeTheme: activeTheme,
                  onSpacingChanged: (newSpacing) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(lineSpacing: newSpacing),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 6. Visual Comfort & Recitation Toggles
                ComfortSettingsSection(
                  preferences: _currentPreferences,
                  onPreferencesChanged: _updatePreferences,
                ),

                AppSpacing.verticalLg,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
