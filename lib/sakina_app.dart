import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/l10n/app_localizations.dart';
import 'package:sakina_app/core/router/app_router.dart';
import 'package:sakina_app/core/theme/app_theme.dart';

class SakinaApp extends StatelessWidget {
  const SakinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'سكينة',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkLuxury,
          routerConfig: appRouter,
          scrollBehavior: const ScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: DevicePreview.locale(context) ?? const Locale('ar'),
          builder: (context, routerChild) {
            return DevicePreview.appBuilder(context, routerChild);
          },
        );
      },
    );
  }
}
