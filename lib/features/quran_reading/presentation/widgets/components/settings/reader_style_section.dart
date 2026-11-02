import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_settings_shared.dart';

/// Reading Style Section: Verse-by-verse vs Continuous Mushaf.
class ReadingStyleSection extends StatelessWidget {
  final QuranReadingStyle selectedStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranReadingStyle> onStyleChanged;

  const ReadingStyleSection({
    super.key,
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
        ReaderSectionTitle(
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
class ScriptStyleSection extends StatelessWidget {
  final QuranScriptStyle selectedScriptStyle;
  final Color accentColor;
  final QuranReaderTheme activeTheme;
  final ValueChanged<QuranScriptStyle> onScriptStyleChanged;

  const ScriptStyleSection({
    super.key,
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
        ReaderSectionTitle(
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

