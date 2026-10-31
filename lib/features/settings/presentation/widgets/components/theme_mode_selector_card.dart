import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

/// Luxury Theme Mode Selector presenting three discrete tactile choices:
/// 1. Dark (الوضع الداكن - OLED Black)
/// 2. Light (رَق السكينة - Calming Parchment Cream from user specifications)
/// 3. System (تلقائي النظام)
/// Zero shadows, 1px gold/border hairline, and tactile haptic response.
class ThemeModeSelectorCard extends StatelessWidget {
  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onModeChanged;

  const ThemeModeSelectorCard({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
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
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.3),
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.colorfilter,
                    size: 20.r,
                    color: colors.accentGold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مَظْهَرُ التَّطْبِيقِ',
                      style: GoogleFonts.cairo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'اخْتَرِ الثِّيمَ المُرِيحَ لِبَصَرِكَ لِتَجْرِبَةٍ رَوْحَانِيَّةٍ',
                      style: GoogleFonts.cairo(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _ThemeOptionTile(
                  title: 'الداكن',
                  subtitle: 'OLED ملكي',
                  icon: Iconsax.moon,
                  isSelected: currentMode == AppThemeMode.dark,
                  previewColor: AppColors.obsidianCore,
                  accentColor: AppColors.champagneGold,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onModeChanged(AppThemeMode.dark);
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _ThemeOptionTile(
                  title: 'رَقُّ السَّكِينَةِ',
                  subtitle: 'كريمي مريح',
                  icon: Iconsax.sun_1,
                  isSelected: currentMode == AppThemeMode.light,
                  previewColor: AppColors.parchmentCore,
                  accentColor: AppColors.warmGold,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onModeChanged(AppThemeMode.light);
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _ThemeOptionTile(
                  title: 'تلقائي',
                  subtitle: 'حسب النظام',
                  icon: Iconsax.mobile,
                  isSelected: currentMode == AppThemeMode.system,
                  previewColor: colors.surfaceElevated,
                  accentColor: colors.accentGold,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onModeChanged(AppThemeMode.system);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color previewColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.previewColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withValues(alpha: 0.12)
                : colors.surfaceElevated,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? accentColor
                  : colors.borderHairline.withValues(alpha: 0.5),
              width: isSelected ? 1.5.r : 1.r,
            ),
          ),
          child: Column(
            children: [
              // Visual Swatch Circle with 1px border
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: previewColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? accentColor : colors.borderHairline,
                    width: 1.2.r,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 16.r,
                    color: isSelected
                        ? accentColor
                        : colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? accentColor : colors.textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

