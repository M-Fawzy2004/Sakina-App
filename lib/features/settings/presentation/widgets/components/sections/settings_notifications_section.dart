import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_switch_tile.dart';

/// Daily Dhikr & Reminders section: morning/evening dhikr, Quran daily portion, daily hope dose, night prayer.
class SettingsNotificationsSection extends StatelessWidget {
  final bool morningEveningAzkar;
  final bool dailyQuranReminder;
  final bool dailyHopeReminder;
  final bool nightPrayerReminder;
  final bool prePrayerReminder;
  final bool rotatingQuranNotifications;
  final ValueChanged<bool> onMorningEveningChanged;
  final ValueChanged<bool> onDailyQuranChanged;
  final ValueChanged<bool> onDailyHopeChanged;
  final ValueChanged<bool> onNightPrayerChanged;
  final ValueChanged<bool> onPrePrayerChanged;
  final ValueChanged<bool> onRotatingQuranChanged;

  const SettingsNotificationsSection({
    super.key,
    required this.morningEveningAzkar,
    required this.dailyQuranReminder,
    required this.dailyHopeReminder,
    required this.nightPrayerReminder,
    required this.prePrayerReminder,
    required this.rotatingQuranNotifications,
    required this.onMorningEveningChanged,
    required this.onDailyQuranChanged,
    required this.onDailyHopeChanged,
    required this.onNightPrayerChanged,
    required this.onPrePrayerChanged,
    required this.onRotatingQuranChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: 'التَّذْكِيرَاتُ وَالوِرْدُ اليَوْمِيُّ',
      icon: Iconsax.notification,
      children: [
        SettingsSwitchTile(
          icon: Iconsax.sun_1,
          title: 'تَنْبِيهَاتُ أَذْكَارِ الصَّبَاحِ وَالمَسَاءِ',
          subtitle: 'تَذْكِيرٌ يَوْمِيٌّ مُنْتَظَمٌ لِحِفْظِ الأَوْقَاتِ',
          value: morningEveningAzkar,
          onChanged: onMorningEveningChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.calendar_tick,
          title: 'تَنْبِيهُ الوِرْدِ القُرْآنِيِّ اليَوْمِيِّ',
          subtitle: 'مُتَابَعَةُ القِرَاءَةِ وَتَحْقِيقُ خَتْمَةِ سَكِينَةَ',
          value: dailyQuranReminder,
          onChanged: onDailyQuranChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.heart,
          title: 'جُرْعَةُ أَمَلٍ يَوْمِيَّةٍ',
          subtitle: 'آيَةٌ وَحَدِيثٌ وَبُشْرَى تُبْعَثُ فِي قَلْبِكَ يَوْمِيًّا',
          value: dailyHopeReminder,
          onChanged: onDailyHopeChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.moon,
          title: 'تَذْكِيرُ قِيَامِ اللَّيْلِ وَالأَسْحَارِ',
          subtitle: 'نَفَحَاتُ الثُّلُثِ الأَخِيرِ مِنَ اللَّيْلِ وَالاسْتِغْفَارِ',
          value: nightPrayerReminder,
          onChanged: onNightPrayerChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.clock,
          title: 'تَنْبِيهَاتُ الصَّلَوَاتِ (قَبْلَ الأَذَانِ بِـ ٥ دَقَائِق)',
          subtitle: 'تَهَيَّأْ لِلْوُقُوفِ بَيْنَ يَدَيْ اللهِ وَإِسْبَاغِ الوُضُوءِ لِكُلِّ صَلَاة',
          value: prePrayerReminder,
          onChanged: onPrePrayerChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.book_1,
          title: 'نَفَحَاتٌ قُرْآنِيَّةٌ مُتَجَدِّدَة (3 مَرَّاتٍ يَوْمِيًّا)',
          subtitle: 'آيَاتٌ مُتَنَوِّعَةٌ عَلَى مَدَارِ اليَوْمِ دُونَ تَكْرَارٍ',
          value: rotatingQuranNotifications,
          onChanged: onRotatingQuranChanged,
        ),
      ],
    );
  }
}

