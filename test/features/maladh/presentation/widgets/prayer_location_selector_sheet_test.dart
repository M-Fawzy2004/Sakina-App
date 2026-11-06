import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/location/gps_location_service.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_location_selector_sheet.dart';

class MockPreferencesService extends Mock implements PreferencesService {}
class MockLocalNotificationService extends Mock implements LocalNotificationService {}
class MockGpsLocationService extends Mock implements GpsLocationService {}

void main() {
  late MockPreferencesService mockPrefs;
  late MockLocalNotificationService mockNotifService;

  setUp(() {
    mockPrefs = MockPreferencesService();
    mockNotifService = MockLocalNotificationService();

    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.getBool(any())).thenReturn(true);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockNotifService.schedulePrePrayerReminders(
          enabled: any(named: 'enabled'),
          prefs: any(named: 'prefs'),
        )).thenAnswer((_) async {});

    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
    GetIt.I.registerSingleton<PreferencesService>(mockPrefs);

    if (GetIt.I.isRegistered<LocalNotificationService>()) {
      GetIt.I.unregister<LocalNotificationService>();
    }
    GetIt.I.registerSingleton<LocalNotificationService>(mockNotifService);
  });

  tearDown(() {
    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
    if (GetIt.I.isRegistered<LocalNotificationService>()) {
      GetIt.I.unregister<LocalNotificationService>();
    }
  });

  Widget buildTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.charcoalLuxury,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('PrayerLocationSelectorSheet filters by search and selects Yemen Sanaa',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);

    CityLocation? selected;

    await tester.pumpWidget(
      buildTestWidget(
        PrayerLocationSelectorSheet(
          currentCity: PrayerLocationCatalog.defaultLocation,
          onCitySelected: (city) => selected = city,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تَحْدِيدُ مَوْقِعِ المَوَاقِيتِ حَوْلَ العَالَم'), findsOneWidget);

    // Search for Yemen
    await tester.enterText(find.byType(TextField), 'صنعاء');
    await tester.pumpAndSettle();

    expect(find.text('• اليمن'), findsOneWidget);

    // Tap on Sanaa tile
    await tester.tap(find.widgetWithText(InkWell, 'صنعاء'));
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(selected, isNotNull);
    expect(selected?.id, 'ye_sanaa');
    expect(selected?.cityNameArabic, 'صنعاء');
    expect(selected?.countryNameArabic, 'اليمن');

    verify(() => mockPrefs.setString(
          PrayerLocationCatalog.keySelectedCityId,
          'ye_sanaa',
        )).called(1);
  });

  testWidgets('PrayerLocationSelectorSheet triggers GPS auto-detection button', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);

    final mockGpsService = MockGpsLocationService();
    when(() => mockGpsService.determineGpsLocation())
        .thenAnswer((_) async => PrayerLocationCatalog.findById('ye_sanaa'));
    GetIt.I.registerSingleton<GpsLocationService>(mockGpsService);
    addTearDown(() {
      if (GetIt.I.isRegistered<GpsLocationService>()) {
        GetIt.I.unregister<GpsLocationService>();
      }
    });

    CityLocation? selected;
    await tester.pumpWidget(
      buildTestWidget(
        PrayerLocationSelectorSheet(
          currentCity: PrayerLocationCatalog.defaultLocation,
          onCitySelected: (city) => selected = city,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تَحْدِيدُ المَوْقِعِ تِلْقَائِيًّا عَبْرَ الأَقْمَارِ الصِّنَاعِيَّةِ (GPS)'), findsOneWidget);

    await tester.tap(find.text('تَحْدِيدُ المَوْقِعِ تِلْقَائِيًّا عَبْرَ الأَقْمَارِ الصِّنَاعِيَّةِ (GPS)'));
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(selected, isNotNull);
    expect(selected?.id, 'ye_sanaa');
    verify(() => mockGpsService.determineGpsLocation()).called(1);
  });
}

