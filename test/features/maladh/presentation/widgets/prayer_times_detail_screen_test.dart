import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/prayer_times_detail_screen.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.getBool(any())).thenReturn(true);

    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
    GetIt.I.registerSingleton<PreferencesService>(mockPrefs);
  });

  tearDown(() {
    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
  });

  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.charcoalLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      ),
    );
  }

  testWidgets('PrayerTimesDetailScreen renders header, calendar card, next countdown, and 6 prayer rows',
      (tester) async {
    await tester.pumpWidget(createTestWidget(const PrayerTimesDetailScreen()));
    await tester.pumpAndSettle();

    // 1. Verify Header & City Name
    expect(find.byType(PrayerTimesDetailScreen), findsOneWidget);

    // 2. Verify 6 daily prayers & celestial times are rendered
    expect(find.text('الفجر'), findsOneWidget);
    expect(find.text('الشروق'), findsOneWidget);
    expect(find.text('الظهر'), findsOneWidget);
    expect(find.text('العصر'), findsOneWidget);
    expect(find.text('المغرب'), findsOneWidget);
    expect(find.text('العشاء'), findsOneWidget);

    // 3. Verify Next Prayer Section
    expect(find.text('الصَّلَاةُ القَادِمَة'), findsOneWidget);

    // 4. Verify user-requested exclusions: MUST NOT render "مضى على أذان" or "أوقات النهي"
    expect(find.textContaining('مضى على'), findsNothing);
    expect(find.textContaining('أوقات النهي'), findsNothing);
  });
}

