import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/domain/entities/app_accent_color.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_font_size_sheet.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';
import 'package:sakina_app/features/settings/presentation/widgets/theme_selector_screen.dart';

/// Appearance & Themes section: theme mode option row, app-wide font size, and script style.
class SettingsAppearanceSection extends StatelessWidget {
  final SettingsState state;
  final double appFontScale;
  final ValueChanged<double> onFontScaleChanged;

  const SettingsAppearanceSection({
    super.key,
    required this.state,
    required this.appFontScale,
    required this.onFontScaleChanged,
  });

  String _getFontScaleLabel(double scale) {
    if (scale <= 0.95) return 'صَغِيرٌ';
    if (scale <= 1.05) return 'مُعْتَدِلٌ (قِيَاسِي)';
    if (scale <= 1.15) return 'مُرِيحٌ';
    if (scale <= 1.25) return 'كَبِيرٌ';
    return 'جَلِيٌّ جِدًّا';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentAccent = AppAccentColor.fromColor(state.primaryAccentColor);

    return SettingsSectionCard(
      title: 'المَظْهَرُ وَالتَّخْصِيصُ',
      icon: Iconsax.colorfilter,
      children: [
        // Theme selection as an ordinary, elegant option row
        SettingsTileItem(
          icon: Iconsax.colorfilter,
          title: 'المَظْهَرُ وَالثِّيمَاتُ وَالأَلْوَانُ',
          subtitle: '${state.appThemeMode.title} • ${currentAccent.title}',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: state.primaryAccentColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Iconsax.arrow_left_2,
                size: 16.r,
                color: colors.accentGold,
              ),
            ],
          ),
          onTap: () {
            HapticService.selectionClick();
            ThemeSelectorScreen.open(context);
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.textalign_justifycenter,
          title: 'حَجْمُ خَطِّ التَّطْبِيقِ وَالنُّصُوصِ',
          subtitle:
              '${_getFontScaleLabel(appFontScale)} (${(appFontScale * 100).toInt()}%) — لِكَافَّةِ الشَّاشَاتِ',
          onTap: () {
            SettingsFontSizeSheet.show(
              context: context,
              currentScale: appFontScale,
              onScaleSelected: (newScale) {
                onFontScaleChanged(newScale);
                AppTopSnackBar.showSuccess(
                  context: context,
                  message:
                      'تم تحديث حجم خط التطبيق بنجاح (${(newScale * 100).toInt()}%)',
                );
              },
            );
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.scroll,
          title: 'الرَّسْمُ العُثْمَانِيُّ المَصْحَفِيُّ',
          subtitle: 'حَفْصٌ عَنْ عَاصِمٍ (مُصْحَفُ المَدِينَةِ المُنَوَّرَةِ)',
          onTap: () {
            HapticService.selectionClick();
            AppTopSnackBar.show(
              context: context,
              message:
                  'الخط معتمد طبقاً لطبعة مجمع الملك فهد لطباعة المصحف الشريف',
            );
          },
        ),
      ],
    );
  }
}

