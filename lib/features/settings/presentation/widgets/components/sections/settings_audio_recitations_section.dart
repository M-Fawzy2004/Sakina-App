import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_options_dialogs.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_reciter_sheet.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_switch_tile.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';

/// Audio Recitations section: default reciter, stream quality, auto-play next, sleep timer.
class SettingsAudioRecitationsSection extends StatelessWidget {
  final String selectedReciter;
  final String audioQuality;
  final bool autoPlayNext;
  final String sleepTimer;
  final ValueChanged<String> onReciterChanged;
  final ValueChanged<String> onAudioQualityChanged;
  final ValueChanged<bool> onAutoPlayNextChanged;
  final ValueChanged<String> onSleepTimerChanged;

  const SettingsAudioRecitationsSection({
    super.key,
    required this.selectedReciter,
    required this.audioQuality,
    required this.autoPlayNext,
    required this.sleepTimer,
    required this.onReciterChanged,
    required this.onAudioQualityChanged,
    required this.onAutoPlayNextChanged,
    required this.onSleepTimerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: 'الصَّوْتِيَّاتُ وَالتِّلَاوَةُ',
      icon: Iconsax.music,
      children: [
        SettingsTileItem(
          icon: Iconsax.user_tag,
          title: 'القَارِئُ الاِفْتِرَاضِيُّ لِلتِّلَاوَةِ',
          subtitle: selectedReciter,
          onTap: () {
            SettingsReciterSheet.show(
              context: context,
              currentReciter: selectedReciter,
              onReciterSelected: (reciter) {
                onReciterChanged(reciter);
                if (context.mounted) {
                  AppTopSnackBar.showSuccess(
                    context: context,
                    message: 'تم اختيار $reciter قارئاً افتراضياً',
                  );
                }
              },
            );
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.music_dashboard,
          title: 'جَوْدَةُ البَثِّ الصَّوْتِيِّ',
          subtitle: audioQuality,
          onTap: () async {
            final selected = await SettingsOptionsDialogs.showAudioQualityDialog(
              context,
              audioQuality,
            );
            if (selected != null) {
              onAudioQualityChanged(selected);
              if (context.mounted) {
                AppTopSnackBar.showSuccess(
                  context: context,
                  message: 'تم تحديث جودة البث الصوتي',
                );
              }
            }
          },
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.play_cricle,
          title: 'التَّشْغِيلُ التِّلْقَائِيُّ لِلتِّلَاوَةِ التَّالِيَةِ',
          subtitle:
              'مُتَابَعَةُ الاسْتِمَاعِ دُونَ انْقِطَاعٍ عِنْدَ انْتِهَاءِ السُّورَةِ',
          value: autoPlayNext,
          onChanged: onAutoPlayNextChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.timer_1,
          title: 'مُؤَقِّتُ النَّوْمِ التِّلْقَائِيُّ',
          subtitle: sleepTimer,
          onTap: () async {
            final selected = await SettingsOptionsDialogs.showSleepTimerDialog(
              context,
              sleepTimer,
            );
            if (selected != null) {
              onSleepTimerChanged(selected);
              if (context.mounted) {
                AppTopSnackBar.show(
                  context: context,
                  message: 'تم ضبط مؤقت النوم: $selected',
                );
              }
            }
          },
        ),
      ],
    );
  }
}
