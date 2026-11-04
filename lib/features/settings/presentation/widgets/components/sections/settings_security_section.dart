import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_switch_tile.dart';

/// Security & Recovery Privacy section: biometrics / PIN lock for Inaba, and stealth mode.
class SettingsSecuritySection extends StatelessWidget {
  final bool inabaBiometricLock;
  final bool stealthNotifications;
  final ValueChanged<bool> onInabaBiometricLockChanged;
  final ValueChanged<bool> onStealthNotificationsChanged;

  const SettingsSecuritySection({
    super.key,
    required this.inabaBiometricLock,
    required this.stealthNotifications,
    required this.onInabaBiometricLockChanged,
    required this.onStealthNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: 'الأَمَانُ وَخُصُوصِيَّةُ الإِنَابَةِ',
      icon: Iconsax.security_safe,
      children: [
        SettingsSwitchTile(
          icon: Iconsax.finger_scan,
          title: 'قَفْلُ قِسْمِ الإِنَابَةِ بِالبَصْمَةِ / PIN',
          subtitle: 'حِمَايَةُ خُصُوصِيَّةِ خُطَطِ التَّعَافِي وَالتَّطَهُّرِ',
          value: inabaBiometricLock,
          onChanged: onInabaBiometricLockChanged,
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsSwitchTile(
          icon: Iconsax.eye_slash,
          title: 'الوَضْعُ السِّرِّيُّ لِلإِشْعَارَاتِ',
          subtitle: 'عَدَمُ إِظْهَارِ نُصُوصِ الإِنَابَةِ عَلَى شَاشَةِ القَفْلِ',
          value: stealthNotifications,
          onChanged: onStealthNotificationsChanged,
        ),
      ],
    );
  }
}

