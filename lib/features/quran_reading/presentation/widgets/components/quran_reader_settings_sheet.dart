import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';

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
          const _DragHandle(),
          AppSpacing.verticalXs,
          _SheetHeader(
            accentColor: activeAccent,
            secondaryTextColor: activeTheme.secondaryTextColor,
          ),
          AppSpacing.verticalSm,
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. Reading Style (Verse-by-verse vs Continuous)
                _ReadingStyleSection(
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
                _ScriptStyleSection(
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
                _FontSizeSection(
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

                // 3. Ambient Reading Themes
                _ThemesSection(
                  selectedTheme: _currentPreferences.theme,
                  onThemeChanged: (newTheme) {
                    HapticService.selectionClick();
                    _updatePreferences(
                      _currentPreferences.copyWith(theme: newTheme),
                    );
                  },
                ),

                AppSpacing.verticalMd,

                // 4. Line Spacing
                _LineSpacingSection(
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

                // 5. Visual Comfort & Recitation Toggles
                _ComfortSettingsSection(
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

/// Draggable modal top handle.
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.champagneGold.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Sheet Header with Calligraphy title and settings icon.
class _SheetHeader extends StatelessWidget {
  final Color accentColor;
  final Color secondaryTextColor;

  const _SheetHeader({
    required this.accentColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Iconsax.setting_2, color: accentColor, size: 20.r),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'إِعْدَادَاتُ المَصْحَفِ الشَّرِيفِ',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'تَخْصِيصُ القِرَاءَةِ',
          style: AppTextStyles.caption.copyWith(
            color: secondaryTextColor,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}

/// Reading Style Section: Verse-by-verse vs Continuous Mushaf.
class _ReadingStyleSection extends StatelessWidget {
  final QuranReadingStyle selectedStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranReadingStyle> onStyleChanged;

  const _ReadingStyleSection({
    required this.selectedStyle,
    required this.accentColor,
    required this.activeTheme,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: Iconsax.row_vertical,
          title: 'نَمَطُ عَرْضِ القِرَاءَةِ',
          accentColor: accentColor,
        ),
        AppSpacing.verticalXs,
        Row(
          children: [
            Expanded(
              child: _ReadingStyleCard(
                title: 'سَرْدٌ آيَةً بِآيَةٍ',
                description: 'كُلُّ آيَةٍ مُنَفَصِلَةٌ مَعَ النَّجْمَةِ',
                icon: Iconsax.row_vertical,
                isSelected: selectedStyle == QuranReadingStyle.verseByVerse,
                accentColor: accentColor,
                activeTheme: activeTheme,
                onTap: () => onStyleChanged(QuranReadingStyle.verseByVerse),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ReadingStyleCard(
                title: 'مُصْحَفٌ مُتَّصِلٌ',
                description: 'آيَاتٌ مُتَتَابِعَةٌ خَلْفَ بَعْضِهَا',
                icon: Iconsax.textalign_justifycenter,
                isSelected: selectedStyle == QuranReadingStyle.continuous,
                accentColor: accentColor,
                activeTheme: activeTheme,
                onTap: () => onStyleChanged(QuranReadingStyle.continuous),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReadingStyleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final VoidCallback onTap;

  const _ReadingStyleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.activeTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withValues(alpha: 0.14)
                : activeTheme.itemBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : activeTheme.borderColor.withValues(alpha: 0.4),
              width: isSelected ? 1.4.r : 1.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 20.r,
                    color: isSelected ? accentColor : activeTheme.secondaryTextColor,
                  ),
                  if (isSelected)
                    Icon(
                      Iconsax.tick_circle,
                      size: 16.r,
                      color: accentColor,
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? accentColor : activeTheme.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: activeTheme.secondaryTextColor,
                  fontSize: 9.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Script Style Section: Calligraphy & writing style selection.
class _ScriptStyleSection extends StatelessWidget {
  final QuranScriptStyle selectedScriptStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranScriptStyle> onScriptStyleChanged;

  const _ScriptStyleSection({
    required this.selectedScriptStyle,
    required this.accentColor,
    required this.activeTheme,
    required this.onScriptStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: Iconsax.edit_2,
          title: 'رَسْمُ وَخَطُّ الكِتَابَةِ القُرْآنِيَّةِ',
          accentColor: accentColor,
        ),
        AppSpacing.verticalXs,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 2.1,
          children: QuranScriptStyle.values.map((style) {
            final isSelected = style == selectedScriptStyle;
            return _ScriptStyleCard(
              style: style,
              isSelected: isSelected,
              accentColor: accentColor,
              activeTheme: activeTheme,
              onTap: () => onScriptStyleChanged(style),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ScriptStyleCard extends StatelessWidget {
  final QuranScriptStyle style;
  final bool isSelected;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final VoidCallback onTap;

  const _ScriptStyleCard({
    required this.style,
    required this.isSelected,
    required this.accentColor,
    required this.activeTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? accentColor.withValues(alpha: 0.16)
          : activeTheme.itemBackgroundColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : activeTheme.borderColor.withValues(alpha: 0.35),
              width: isSelected ? 1.5.r : 0.8.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      style.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? accentColor : activeTheme.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Iconsax.tick_circle,
                      size: 15.r,
                      color: accentColor,
                    ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                style.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: activeTheme.secondaryTextColor,
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Font Size Section with 4 calibrated steps and live verse preview.
class _FontSizeSection extends StatelessWidget {
  final QuranFontSize selectedSize;
  final QuranScriptStyle scriptStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final QuranLineSpacing lineSpacing;
  final ValueChanged<QuranFontSize> onSizeChanged;

  const _FontSizeSection({
    required this.selectedSize,
    required this.scriptStyle,
    required this.accentColor,
    required this.activeTheme,
    required this.lineSpacing,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _SectionTitle(
                icon: Iconsax.text,
                title: 'حَجْمُ الخَطِّ القُرْآنِيِّ (4 أَحْجَامٍ)',
                accentColor: accentColor,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: selectedSize.index > 0
                      ? () => onSizeChanged(
                            QuranFontSize.values[selectedSize.index - 1],
                          )
                      : null,
                  icon: Icon(
                    Iconsax.minus_cirlce,
                    color: selectedSize.index > 0
                        ? accentColor
                        : activeTheme.secondaryTextColor.withValues(alpha: 0.4),
                    size: 22.r,
                  ),
                ),
                Text(
                  '${selectedSize.displaySp}sp',
                  style: AppTextStyles.caption.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: selectedSize.index < QuranFontSize.values.length - 1
                      ? () => onSizeChanged(
                            QuranFontSize.values[selectedSize.index + 1],
                          )
                      : null,
                  icon: Icon(
                    Iconsax.add_circle,
                    color: selectedSize.index < QuranFontSize.values.length - 1
                        ? accentColor
                        : activeTheme.secondaryTextColor.withValues(alpha: 0.4),
                    size: 22.r,
                  ),
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalXs,
        _FontSizeSegmentedBar(
          selectedSize: selectedSize,
          accentColor: accentColor,
          activeTheme: activeTheme,
          onSizeChanged: onSizeChanged,
        ),
        SizedBox(height: 10.h),
        _LiveFontPreviewBox(
          fontSizeDelta: selectedSize.scaleDelta,
          scriptStyle: scriptStyle,
          accentColor: accentColor,
          activeTheme: activeTheme,
          lineSpacing: lineSpacing,
        ),
      ],
    );
  }
}

class _FontSizeSegmentedBar extends StatelessWidget {
  final QuranFontSize selectedSize;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranFontSize> onSizeChanged;

  const _FontSizeSegmentedBar({
    required this.selectedSize,
    required this.accentColor,
    required this.activeTheme,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: activeTheme.itemBackgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: activeTheme.borderColor.withValues(alpha: 0.3),
          width: 1.r,
        ),
      ),
      child: Row(
        children: QuranFontSize.values.map((size) {
          final isSelected = size == selectedSize;
          return Expanded(
            child: InkWell(
              onTap: () => onSizeChanged(size),
              borderRadius: BorderRadius.circular(10.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.22)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: isSelected
                      ? Border.all(color: accentColor, width: 1.r)
                      : null,
                ),
                child: Center(
                  child: Text(
                    size.title,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? accentColor : activeTheme.textColor,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 11.5.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Live preview card rendering a sacred Quran verse at the selected size and script style.
class _LiveFontPreviewBox extends StatelessWidget {
  final double fontSizeDelta;
  final QuranScriptStyle scriptStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final QuranLineSpacing lineSpacing;

  const _LiveFontPreviewBox({
    required this.fontSizeDelta,
    required this.scriptStyle,
    required this.accentColor,
    required this.activeTheme,
    required this.lineSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final previewText = scriptStyle == QuranScriptStyle.uthmani
        ? '﴿ بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ﴾'
        : (scriptStyle == QuranScriptStyle.indopak
            ? '﴿ بِسۡمِ اللهِ الرَّحۡمٰنِ الرَّحِيۡمِ ﴾'
            : '﴿ بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ﴾');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: activeTheme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: activeTheme.borderColor.withValues(alpha: 0.45),
          width: 0.8.r,
        ),
      ),
      child: Column(
        children: [
          Text(
            'مُعَايَنَةُ الخَطِّ الحَيَّة (${scriptStyle.title})',
            style: AppTextStyles.caption.copyWith(
              color: activeTheme.secondaryTextColor,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              previewText,
              textAlign: TextAlign.center,
              style: AppTextStyles.quranScriptStyleOf(scriptStyle).copyWith(
                fontSize: 22.sp + fontSizeDelta,
                color: activeTheme.textColor,
                height: lineSpacing.height,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Spiritual Themes Ambient Section.
class _ThemesSection extends StatelessWidget {
  final QuranReaderTheme selectedTheme;
  final ValueChanged<QuranReaderTheme> onThemeChanged;

  const _ThemesSection({
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: Iconsax.colorfilter,
          title: 'بِيئَةُ وَمَظْهَرُ القِرَاءَةِ (${QuranReaderTheme.values.length} ثِيمَاتٍ)',
          accentColor: selectedTheme.accentColor,
        ),
        AppSpacing.verticalXs,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: QuranReaderTheme.values.map((theme) {
              final isSelected = theme == selectedTheme;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: SizedBox(
                  width: 86.w,
                  child: _ThemePill(
                    theme: theme,
                    activeTheme: selectedTheme,
                    isSelected: isSelected,
                    onTap: () => onThemeChanged(theme),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ThemePill extends StatelessWidget {
  final QuranReaderTheme theme;
  final QuranReaderTheme activeTheme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePill({
    required this.theme,
    required this.activeTheme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.accentColor.withValues(alpha: 0.2)
                : activeTheme.itemBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? theme.accentColor
                  : activeTheme.borderColor.withValues(alpha: 0.35),
              width: isSelected ? 1.3.r : 0.8.r,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.accentColor, width: 1.5.r),
                ),
                child: Center(
                  child: Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                theme.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? theme.accentColor : activeTheme.textColor,
                  fontWeight:
                      isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 10.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Line Spacing Selector Section.
class _LineSpacingSection extends StatelessWidget {
  final QuranLineSpacing selectedSpacing;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranLineSpacing> onSpacingChanged;

  const _LineSpacingSection({
    required this.selectedSpacing,
    required this.accentColor,
    required this.activeTheme,
    required this.onSpacingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: Iconsax.document_text,
          title: 'تَبَاعُدُ الأَسْطُرِ (لِرَاحَةِ التَّشْكِيلِ)',
          accentColor: accentColor,
        ),
        AppSpacing.verticalXs,
        Row(
          children: QuranLineSpacing.values.map((spacing) {
            final isSelected = spacing == selectedSpacing;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () => onSpacingChanged(spacing),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor.withValues(alpha: 0.18)
                          : activeTheme.itemBackgroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? accentColor
                            : activeTheme.borderColor.withValues(alpha: 0.3),
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        spacing.title,
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected ? accentColor : activeTheme.textColor,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Comfort settings & Auto-Scroll recitation toggles.
class _ComfortSettingsSection extends StatelessWidget {
  final QuranReaderPreferences preferences;
  final ValueChanged<QuranReaderPreferences> onPreferencesChanged;

  const _ComfortSettingsSection({
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
        _SectionTitle(
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: accentColor),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 13.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}
