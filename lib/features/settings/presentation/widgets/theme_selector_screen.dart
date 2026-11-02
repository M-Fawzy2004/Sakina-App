import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/theme_accent_color_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/theme_preview_card_large.dart';

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
          icon: Icon(
            Iconsax.arrow_right_3,
            color: colors.textPrimary,
            size: 22.r,
          ),
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
            icon: Icon(
              Iconsax.rotate_left,
              size: 16.r,
              color: colors.accentGold,
            ),
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
                ThemeAccentColorSection(
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
                  return ThemePreviewCardLarge(
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
