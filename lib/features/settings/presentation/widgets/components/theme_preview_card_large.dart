import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

/// Large, Luxury Preview Card for Each Theme.
class ThemePreviewCardLarge extends StatelessWidget {
  final AppThemeMode mode;
  final bool isSelected;
  final Color activeAccentColor;
  final VoidCallback onTap;

  const ThemePreviewCardLarge({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.activeAccentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final previewConfig = _getPreviewConfig(mode, activeAccentColor);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? colors.accentGold
                    : colors.borderHairline.withValues(alpha: 0.65),
                width: isSelected ? 2.r : 1.r,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Mini Live Quranic Card Preview Box
                Container(
                  height: 96.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: previewConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: previewConfig.borderColor,
                      width: 1.r,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header: Surah Name Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: previewConfig.cardColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'سُورَةُ الفَاتِحَةِ',
                              style: GoogleFonts.cairo(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w700,
                                color: previewConfig.accentColor,
                              ),
                            ),
                          ),
                          Text(
                            'الجُزْءُ ١ • الصَّفْحَةُ ١',
                            style: GoogleFonts.cairo(
                              fontSize: 9.sp,
                              color: previewConfig.textColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),

                      // Calligraphy Center
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: previewConfig.accentColor,
                          height: 1.2,
                        ),
                      ),

                      // Ayah Preview Snippet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
                            style: GoogleFonts.amiri(
                              fontSize: 13.sp,
                              color: previewConfig.textColor,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            width: 18.r,
                            height: 18.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: previewConfig.accentColor,
                                width: 0.8.r,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '١',
                                style: GoogleFonts.cairo(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color: previewConfig.accentColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // 2. Metadata & Radio Indicator Row
                Row(
                  children: [
                    // Radio Selection Indicator
                    Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? colors.accentGold
                              : colors.textSecondary.withValues(alpha: 0.5),
                          width: 2.r,
                        ),
                        color: isSelected
                            ? colors.accentGold
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 14.r,
                              color: colors.background,
                            )
                          : null,
                    ),

                    SizedBox(width: 10.w),

                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                mode.title,
                                style: GoogleFonts.cairo(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              if (mode == AppThemeMode.charcoal) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.accentGold
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'الأسَاسِيُّ',
                                    style: GoogleFonts.cairo(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.accentGold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            mode.subtitle,
                            style: GoogleFonts.cairo(
                              fontSize: 11.5.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ThemePreviewConfig _getPreviewConfig(
    AppThemeMode mode,
    Color activeAccentColor,
  ) {
    return switch (mode) {
      AppThemeMode.charcoal => _ThemePreviewConfig(
          backgroundColor: AppColors.charcoalCore,
          cardColor: AppColors.charcoalCard,
          borderColor: AppColors.charcoalBorder,
          textColor: AppColors.pureChalk,
          accentColor: activeAccentColor,
        ),
      AppThemeMode.dark => _ThemePreviewConfig(
          backgroundColor: AppColors.obsidianCore,
          cardColor: AppColors.carbonSlate,
          borderColor: AppColors.goldBorderStroke,
          textColor: AppColors.pureChalk,
          accentColor: activeAccentColor,
        ),
      AppThemeMode.emerald => _ThemePreviewConfig(
          backgroundColor: AppColors.emeraldSanctuaryCore,
          cardColor: AppColors.emeraldSanctuaryCard,
          borderColor: AppColors.emeraldSanctuaryBorder,
          textColor: AppColors.pureChalk,
          accentColor: activeAccentColor,
        ),
      AppThemeMode.light => _ThemePreviewConfig(
          backgroundColor: AppColors.parchmentCore,
          cardColor: AppColors.parchmentCard,
          borderColor: AppColors.parchmentBorder,
          textColor: AppColors.inkDeep,
          accentColor: activeAccentColor,
        ),
      AppThemeMode.system => _ThemePreviewConfig(
          backgroundColor: AppColors.charcoalCore,
          cardColor: AppColors.charcoalCard,
          borderColor: AppColors.charcoalBorder,
          textColor: AppColors.pureChalk,
          accentColor: activeAccentColor,
        ),
    };
  }
}

class _ThemePreviewConfig {
  final Color backgroundColor;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color accentColor;

  const _ThemePreviewConfig({
    required this.backgroundColor,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.accentColor,
  });
}

