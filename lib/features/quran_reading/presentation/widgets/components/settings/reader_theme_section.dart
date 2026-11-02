import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/settings/reader_settings_shared.dart';

/// Spiritual Themes Ambient Section.
class ThemesSection extends StatelessWidget {
  final QuranReaderTheme selectedTheme;
  final ValueChanged<QuranReaderTheme> onThemeChanged;

  const ThemesSection({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReaderSectionTitle(
          icon: Iconsax.colorfilter,
          title:
              'بِيئَةُ وَمَظْهَرُ القِرَاءَةِ (${QuranReaderTheme.values.length} ثِيمَاتٍ)',
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

