import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/domain/entities/app_accent_color.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';

/// Dedicated Luxury Theme & Accent Customization Screen.
/// Provides large tactile preview cards for all 5 themes,
/// a curated primary accent color palette, and reset to defaults.
class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  /// Navigates to the dedicated theme customization sanctuary screen.
  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const ThemeSelectorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_right_3, color: colors.textPrimary, size: 22.r),
          onPressed: () {
            HapticService.selectionClick();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'المَظْهَرُ وَالأَلْوَانُ',
          style: GoogleFonts.cairo(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _confirmReset(context),
            icon: Icon(Iconsax.rotate_left, size: 16.r, color: colors.accentGold),
            label: Text(
              'الافتراضي',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colors.accentGold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                // 1. Primary Accent Color Customization
                _AccentColorSection(
                  selectedColor: state.primaryAccentColor,
                  onColorSelected: (accent) {
                    HapticService.selectionClick();
                    cubit.setPrimaryAccentColor(accent.color);
                  },
                ),

                SizedBox(height: 24.h),

                // 2. Themes Header
                Row(
                  children: [
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: colors.borderHairline.withValues(alpha: 0.5),
                          width: 0.8.r,
                        ),
                      ),
                      child: Icon(
                        Iconsax.brush_1,
                        size: 16.r,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ثِيمَاتُ المَصْحَفِ الشَّرِيفِ',
                            style: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            'اختر النمط البصري الأنسب لراحتك أثناء القراءة والتأمل',
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

                SizedBox(height: 14.h),

                // 3. Large Luxurious Theme Cards
                ...AppThemeMode.values.map((mode) {
                  return _ThemeCardLarge(
                    mode: mode,
                    isSelected: state.appThemeMode == mode,
                    activeAccentColor: state.primaryAccentColor,
                    onTap: () {
                      HapticService.selectionClick();
                      cubit.setThemeMode(mode);
                    },
                  );
                }),

                SizedBox(height: bottomPadding + 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final colors = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(color: colors.borderHairline),
          ),
          title: Row(
            children: [
              Icon(Iconsax.rotate_left, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'استعادة المظهر الافتراضي',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'هل تود استعادة الثيم الفحمي الحديث واللون الذهبي الملكي الافتراضي؟',
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'إلغاء',
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
              ),
              child: Text(
                'استعادة الآن',
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

    if (confirmed == true && context.mounted) {
      HapticService.selectionClick();
      context.read<SettingsCubit>().resetToDefaults();
      AppTopSnackBar.show(
        context: context,
        message: 'تمت استعادة المظهر الافتراضي بنجاح',
        icon: Iconsax.tick_circle,
      );
    }
  }
}

/// Curated Jewel Palette for Primary Accent Color Selection.
class _AccentColorSection extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<AppAccentColor> onColorSelected;

  const _AccentColorSection({
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.65),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colors.borderHairline.withValues(alpha: 0.5),
                    width: 0.8.r,
                  ),
                ),
                child: Icon(
                  Iconsax.colorfilter,
                  size: 16.r,
                  color: colors.accentGold,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لَوْنُ التَّمْيِيزِ الأَسَاسِيُّ (Primary Accent)',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'يتحكم في إضاءة الآيات، أزرار التبويبات، واللمسات الملكية',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Horizontal Palette of Jewels
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.center,
            children: AppAccentColor.allAccents.map((accent) {
              final isSelected =
                  accent.color.toARGB32() == selectedColor.toARGB32();

              return InkWell(
                onTap: () => onColorSelected(accent),
                borderRadius: BorderRadius.circular(28.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: accent.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.2.r,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accent.color.withValues(alpha: 0.55),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 22.r,
                              color: accent.color.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white,
                            )
                          : null,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      accent.title.split(' ').first,
                      style: GoogleFonts.cairo(
                        fontSize: 10.5.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Large, Luxury Preview Card for Each Theme.
class _ThemeCardLarge extends StatelessWidget {
  final AppThemeMode mode;
  final bool isSelected;
  final Color activeAccentColor;
  final VoidCallback onTap;

  const _ThemeCardLarge({
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
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.accentGold.withValues(alpha: 0.15),
                        blurRadius: 12.r,
                        spreadRadius: 1.r,
                      ),
                    ]
                  : null,
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
