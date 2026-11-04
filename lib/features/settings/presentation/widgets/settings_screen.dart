import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_reset_dialog.dart';
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
/// Clean, modular, comprehensive settings backed 100% by persistent local storage.
/// Zero drop shadows and pure ScreenUtil responsive design.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Quran & Display Settings
  String _readingStyle = 'كُرُوتُ الآيَاتِ المُنْفَرِدَةِ مَعَ إِضَاءَةِ التِّلَاوَةِ';
  bool _keepScreenAwake = true;

  // Audio Recitations Settings
  String _selectedReciterId = 'Alafasy_128kbps';
  String _selectedReciterName = 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي';
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
  void initState() {
    super.initState();
    _loadPersistedSettings();
  }

  void _loadPersistedSettings() {
    final prefs = sl<PreferencesService>();
    final data = SettingsPersistenceManager.load(prefs);
    _selectedReciterId = data.reciterId;
    _selectedReciterName = data.reciterName;
    _audioQuality = data.audioQuality;
    _autoPlayNext = data.autoPlayNext;
    _sleepTimer = data.sleepTimer;
    _readingStyle = data.readingStyle;
    _keepScreenAwake = data.keepAwake;
    _morningEveningAzkar = data.morningEveningAzkar;
    _dailyQuranReminder = data.dailyQuranReminder;
    _dailyHopeReminder = data.dailyHopeReminder;
    _nightPrayerReminder = data.nightPrayerReminder;
    _inabaBiometricLock = data.inabaLock;
    _stealthNotifications = data.stealthNotifications;
  }

  Future<void> _updateBoolPref(
    String key,
    bool val,
    void Function(bool) setter,
    String toastMessage,
  ) async {
    HapticService.selectionClick();
    setState(() => setter(val));
    await sl<PreferencesService>().setBool(key, val);
    if (mounted) {
      AppTopSnackBar.showSuccess(context: context, message: toastMessage);
    }
  }

  Future<void> _handleReciterChanged(String id, String name) async {
    setState(() {
      _selectedReciterId = id;
      _selectedReciterName = name;
    });
    final prefs = sl<PreferencesService>();
    await prefs.setString(SettingsPersistenceManager.keyReciterId, id);
    await prefs.setString(SettingsPersistenceManager.keyReciterName, name);
    if (mounted) {
      context.read<QuranCubit>().setReciter(id);
    }
  }

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

                  // 2. Serene Spiritual Sanctuary Overview Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const SettingsSanctuaryCard(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 3. Appearance & Themes (Theme & App-Wide Font Scale)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsAppearanceSection(
                        state: state,
                        appFontScale: state.textScaleFactor,
                        onFontScaleChanged: (newScale) {
                          cubit.setTextScaleFactor(newScale);
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
                        onReadingStyleChanged: (newStyle) async {
                          setState(() => _readingStyle = newStyle);
                          await sl<PreferencesService>().setString(
                            SettingsPersistenceManager.keyReadingStyle,
                            newStyle,
                          );
                        },
                        onKeepScreenAwakeChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyKeepAwake,
                            val,
                            (v) => _keepScreenAwake = v,
                            val
                                ? 'تم تفعيل إبقاء الشاشة مضاءة أثناء القراءة'
                                : 'تم تعطيل إبقاء الشاشة مضاءة',
                          );
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 5. Audio Recitations Sanctuary (Per-Ayah & Maladh Reciter)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsAudioRecitationsSection(
                        selectedReciterId: _selectedReciterId,
                        selectedReciterName: _selectedReciterName,
                        audioQuality: _audioQuality,
                        autoPlayNext: _autoPlayNext,
                        sleepTimer: _sleepTimer,
                        onReciterChanged: _handleReciterChanged,
                        onAudioQualityChanged: (quality) async {
                          setState(() => _audioQuality = quality);
                          await sl<PreferencesService>().setString(
                            SettingsPersistenceManager.keyAudioQuality,
                            quality,
                          );
                        },
                        onAutoPlayNextChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyAutoPlayNext,
                            val,
                            (v) => _autoPlayNext = v,
                            val
                                ? 'تم تفعيل التشغيل التلقائي للتلاوة التالية'
                                : 'تم تعطيل التشغيل التلقائي',
                          );
                        },
                        onSleepTimerChanged: (timer) async {
                          setState(() => _sleepTimer = timer);
                          await sl<PreferencesService>().setString(
                            SettingsPersistenceManager.keySleepTimer,
                            timer,
                          );
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
                          _updateBoolPref(
                            SettingsPersistenceManager.keyMorningEveningAzkar,
                            val,
                            (v) => _morningEveningAzkar = v,
                            val
                                ? 'تم تفعيل تذكيرات أذكار الصباح والمساء 🌿'
                                : 'تم إيقاف تذكيرات أذكار الصباح والمساء',
                          );
                        },
                        onDailyQuranChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyDailyQuranReminder,
                            val,
                            (v) => _dailyQuranReminder = v,
                            val
                                ? 'تم تفعيل تنبيه الورد القرآني اليومي 📖'
                                : 'تم إيقاف تنبيه الورد القرآني',
                          );
                        },
                        onDailyHopeChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyDailyHopeReminder,
                            val,
                            (v) => _dailyHopeReminder = v,
                            val
                                ? 'تم تفعيل جرعة الأمل اليومية ✨'
                                : 'تم إيقاف جرعة الأمل اليومية',
                          );
                        },
                        onNightPrayerChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyNightPrayerReminder,
                            val,
                            (v) => _nightPrayerReminder = v,
                            val
                                ? 'تم تفعيل تذكير قيام الليل والأسحار 🌙'
                                : 'تم إيقاف تذكير قيام الليل',
                          );
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
                          _updateBoolPref(
                            SettingsPersistenceManager.keyInabaLock,
                            val,
                            (v) => _inabaBiometricLock = v,
                            val
                                ? 'تم تفعيل حماية قسم الإنابة بـ PIN / البصمة 🛡️'
                                : 'تم تعطيل قفل قسم الإنابة',
                          );
                        },
                        onStealthNotificationsChanged: (val) {
                          _updateBoolPref(
                            SettingsPersistenceManager.keyStealthNotifications,
                            val,
                            (v) => _stealthNotifications = v,
                            val
                                ? 'تم تفعيل الوضع السري لإشعارات الإنابة 🔒'
                                : 'تم إيقاف الوضع السري للإشعارات',
                          );
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

                  // 9. About Sanctuary Card & Developer Contact
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SettingsAboutSanctuaryCard(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 10. Reset to Factory Defaults Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsResetCard(
                        onResetTap: () => _showResetConfirmationDialog(cubit),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(height: 90.h + bottomPadding),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showResetConfirmationDialog(SettingsCubit cubit) async {
    final confirmed = await SettingsResetDialog.show(context);
    if (confirmed == true && mounted) {
      HapticService.selectionClick();
      await cubit.resetToDefaults();
      await SettingsPersistenceManager.resetAll(sl<PreferencesService>());
      if (!mounted) return;
      setState(() => _loadPersistedSettings());
      AppTopSnackBar.showSuccess(
        context: context,
        message: 'تمت استعادة الإعدادات الافتراضية بنجاح 🌿',
      );
    }
  }
}
