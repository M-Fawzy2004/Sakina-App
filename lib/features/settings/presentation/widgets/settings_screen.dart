import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_appearance_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_audio_recitations_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_notifications_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_quran_reading_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_security_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/sections/settings_storage_section.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_about_sanctuary_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_brand_header.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_reset_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_sanctuary_card.dart';

/// Al-I'dadat (Settings & Preferences) Sanctuary Screen.
/// Clean, modular, comprehensive settings without drop shadows.
/// Replaces the top hero billboard with a spiritual sanctuary overview card,
/// presenting theme customization as an ordinary, elegant option row.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Quran & Display Settings
  double _quranFontSize = 26.0;
  String _readingStyle = 'كُرُوتُ الآيَاتِ المُنْفَرِدَةِ مَعَ إِضَاءَةِ التِّلَاوَةِ';
  bool _keepScreenAwake = true;

  // Audio Recitations Settings
  String _selectedReciter = 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي';
  String _audioQuality = 'جَوْدَةٌ عَالِيَةٌ (HQ 128 kbps) — نَقَاءُ اسْتُودْيُو';
  bool _autoPlayNext = true;
  String _sleepTimer = 'مُعَطَّلٌ حَالِيًّا';

  // Notifications & Dhikr
  bool _morningEveningAzkar = true;
  bool _dailyQuranReminder = true;
  bool _dailyHopeReminder = true;
  bool _nightPrayerReminder = false;

  // Security & Inaba
  bool _inabaBiometricLock = true;
  bool _stealthNotifications = false;

  // Storage Cache
  String _cacheSizeText = '١٨.٤ م.ب';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Top Sacred Brand Header
                  const SliverToBoxAdapter(
                    child: SettingsBrandHeader(),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),

                  // 2. Serene Spiritual Sanctuary Overview Card (Replacing Hero)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const SettingsSanctuaryCard(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 3. Appearance & Themes (Theme as a Standard Option Tile)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsAppearanceSection(
                        state: state,
                        quranFontSize: _quranFontSize,
                        onFontSizeChanged: (newSize) {
                          setState(() => _quranFontSize = newSize);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 4. Quran Reading Sanctuary Preferences
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsQuranReadingSection(
                        readingStyle: _readingStyle,
                        keepScreenAwake: _keepScreenAwake,
                        onReadingStyleChanged: (newStyle) {
                          setState(() => _readingStyle = newStyle);
                        },
                        onKeepScreenAwakeChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _keepScreenAwake = val);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 5. Audio Recitations Sanctuary
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsAudioRecitationsSection(
                        selectedReciter: _selectedReciter,
                        audioQuality: _audioQuality,
                        autoPlayNext: _autoPlayNext,
                        sleepTimer: _sleepTimer,
                        onReciterChanged: (reciter) {
                          setState(() => _selectedReciter = reciter);
                        },
                        onAudioQualityChanged: (quality) {
                          setState(() => _audioQuality = quality);
                        },
                        onAutoPlayNextChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _autoPlayNext = val);
                        },
                        onSleepTimerChanged: (timer) {
                          setState(() => _sleepTimer = timer);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 6. Daily Dhikr & Reminders
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsNotificationsSection(
                        morningEveningAzkar: _morningEveningAzkar,
                        dailyQuranReminder: _dailyQuranReminder,
                        dailyHopeReminder: _dailyHopeReminder,
                        nightPrayerReminder: _nightPrayerReminder,
                        onMorningEveningChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _morningEveningAzkar = val);
                        },
                        onDailyQuranChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _dailyQuranReminder = val);
                        },
                        onDailyHopeChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _dailyHopeReminder = val);
                        },
                        onNightPrayerChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _nightPrayerReminder = val);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 7. Security & Inaba Privacy
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsSecuritySection(
                        inabaBiometricLock: _inabaBiometricLock,
                        stealthNotifications: _stealthNotifications,
                        onInabaBiometricLockChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _inabaBiometricLock = val);
                        },
                        onStealthNotificationsChanged: (val) {
                          HapticService.selectionClick();
                          setState(() => _stealthNotifications = val);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 8. Storage & Cache Management
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsStorageSection(
                        cacheSizeText: _cacheSizeText,
                        onCacheCleared: (newSize) {
                          setState(() => _cacheSizeText = newSize);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 9. About Sakina & Perpetual Charity (صدقة جارية)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const SettingsAboutSanctuaryCard(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 10. Reset to Defaults
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsResetCard(
                        onResetTap: () => _confirmResetAll(cubit),
                      ),
                    ),
                  ),

                  // Bottom padding for floating navigation bar
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomPadding + 96.h),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmResetAll(SettingsCubit cubit) async {
    final colors = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(
              color: colors.borderHairline.withValues(alpha: 0.8),
              width: 1.r,
            ),
          ),
          title: Row(
            children: [
              Icon(Iconsax.rotate_left, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'استعادة الإعدادات الافتراضية',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'هل تود إعادة تعيين الثيم، لون التمييز الأساسي، وكافة الإعدادات إلى الضبط الأولي للمصنع؟',
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
                elevation: 0,
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

    if (confirmed == true && mounted) {
      HapticService.selectionClick();
      await cubit.resetToDefaults();
      if (!mounted) return;
      setState(() {
        _quranFontSize = 26.0;
        _readingStyle = 'كُرُوتُ الآيَاتِ المُنْفَرِدَةِ مَعَ إِضَاءَةِ التِّلَاوَةِ';
        _keepScreenAwake = true;
        _selectedReciter = 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي';
        _audioQuality = 'جَوْدَةٌ عَالِيَةٌ (HQ 128 kbps) — نَقَاءُ اسْتُودْيُو';
        _autoPlayNext = true;
        _sleepTimer = 'مُعَطَّلٌ حَالِيًّا';
        _morningEveningAzkar = true;
        _dailyQuranReminder = true;
        _dailyHopeReminder = true;
        _nightPrayerReminder = false;
        _inabaBiometricLock = true;
        _stealthNotifications = false;
        _cacheSizeText = '١٨.٤ م.ب';
      });
      AppTopSnackBar.show(
        context: context,
        message: 'تمت استعادة الإعدادات الافتراضية بنجاح',
        icon: Iconsax.tick_circle,
      );
    }
  }
}
