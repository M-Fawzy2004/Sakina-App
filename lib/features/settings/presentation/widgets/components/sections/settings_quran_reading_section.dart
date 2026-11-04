import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_options_dialogs.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_switch_tile.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';

/// Quran Reading Sanctuary section: reading style, tafsir, and keep awake toggle.
class SettingsQuranReadingSection extends StatelessWidget {
  final String readingStyle;
  final bool keepScreenAwake;
  final ValueChanged<String> onReadingStyleChanged;
  final ValueChanged<bool> onKeepScreenAwakeChanged;

  const SettingsQuranReadingSection({
    super.key,
    required this.readingStyle,
    required this.keepScreenAwake,
    required this.onReadingStyleChanged,
    required this.onKeepScreenAwakeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: 'تَفْضِيلَاتُ المَصْحَفِ وَالقِرَاءَةِ',
      icon: Iconsax.book_1,
      children: [
        SettingsTileItem(
          icon: Iconsax.document_text,
          title: 'نَمَطُ عَرْضِ القِرَاءَةِ',
          subtitle: readingStyle,
          onTap: () async {
            final selected = await SettingsOptionsDialogs.showReadingStyleDialog(
              context,
              readingStyle,
            );
            if (selected != null) {
              onReadingStyleChanged(selected);
              if (context.mounted) {
                AppTopSnackBar.showSuccess(
                  context: context,
                  message: 'تم تغيير نمط عرض المصحف بنجاح',
                );
              }
            }
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.book,
          title: 'التَّفْسِيرُ الاِفْتِرَاضِيُّ لِلآيَاتِ',
          subtitle: 'التَّفْسِيرُ المُيَسَّرُ (مَجْمَعُ المَلِكِ فَهْدٍ)',
          onTap: () {
            HapticService.selectionClick();
            AppTopSnackBar.show(
              context: context,
              message: 'التفسير الميسر مفعل افتراضياً في قراءة وتدبر الآيات',
            );
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.lamp_on,
          title: 'إِبْقَاءُ الشَّاشَةِ مُضَاءَةً أَثْنَاءَ القِرَاءَةِ',
          subtitle: 'مَنْعُ قَفْلِ الشَّاشَةِ التِّلْقَائِيِّ عِنْدَ تَدَبُّرِ الآيَاتِ',
          value: keepScreenAwake,
          onChanged: onKeepScreenAwakeChanged,
        ),
      ],
    );
  }
}
