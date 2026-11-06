import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/l10n/app_localizations.dart';
import 'package:sakina_app/core/router/app_router.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/home_widgets/domain/services/home_widget_sync_service.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';

class SakinaApp extends StatefulWidget {
  const SakinaApp({super.key});

  @override
  State<SakinaApp> createState() => _SakinaAppState();
}

class _SakinaAppState extends State<SakinaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    HomeWidgetSyncService.initializeDeepLinks(appRouter);
    _syncWidgets();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncWidgets();
    }
  }

  void _syncWidgets() {
    final prefs = sl.isRegistered<PreferencesService>() ? sl<PreferencesService>() : null;
    unawaited(HomeWidgetSyncService.syncAllWidgets(prefs: prefs));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HomeWidgetSyncService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: sl<SettingsCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return MaterialApp.router(
                title: 'سَكِينَة',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.themeFor(
                  settingsState.appThemeMode,
                  isSystemDark: false,
                  primaryAccent: settingsState.primaryAccentColor,
                ),
                darkTheme: AppTheme.themeFor(
                  settingsState.appThemeMode,
                  isSystemDark: true,
                  primaryAccent: settingsState.primaryAccentColor,
                ),
                themeMode: settingsState.themeMode,
                routerConfig: appRouter,
                scrollBehavior: const ScrollBehavior().copyWith(
                  physics: const BouncingScrollPhysics(),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: DevicePreview.locale(context) ?? const Locale('ar'),
                builder: (context, routerChild) {
                  final scaledChild = MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler:
                          TextScaler.linear(settingsState.textScaleFactor),
                    ),
                    child: routerChild ?? const SizedBox.shrink(),
                  );
                  return DevicePreview.appBuilder(context, scaledChild);
                },
              );
            },
          );
        },
      ),
    );
  }
}
