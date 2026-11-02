import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_settings_shared.dart';

/// Font Size Section with 4 calibrated steps and live verse preview.
class FontSizeSection extends StatelessWidget {
  final QuranFontSize selectedSize;
  final QuranScriptStyle scriptStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final QuranLineSpacing lineSpacing;
  final ValueChanged<QuranFontSize> onSizeChanged;

  const FontSizeSection({
    super.key,
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
              child: ReaderSectionTitle(
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

/// Line Spacing Selector Section.
class LineSpacingSection extends StatelessWidget {
  final QuranLineSpacing selectedSpacing;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranLineSpacing> onSpacingChanged;

  const LineSpacingSection({
    super.key,
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
        ReaderSectionTitle(
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

