import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_istighfar_card.dart';

class MockIstighfarLocalDataSource extends Mock
    implements IstighfarLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockIstighfarLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockIstighfarLocalDataSource();
    when(() => mockDataSource.getTotalLifetimeCount())
        .thenAnswer((_) async => 1250);

    if (sl.isRegistered<IstighfarLocalDataSource>()) {
      sl.unregister<IstighfarLocalDataSource>();
    }
    sl.registerLazySingleton<IstighfarLocalDataSource>(() => mockDataSource);
  });

  tearDown(() {
    if (sl.isRegistered<IstighfarLocalDataSource>()) {
      sl.unregister<IstighfarLocalDataSource>();
    }
  });

  testWidgets('MaladhIstighfarCard renders title, excerpt, and responds to tap',
      (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: MaladhIstighfarCard(
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('مَسْبَحَةُ الاسْتِغْفَارِ وَالتَّسْبِيح'), findsOneWidget);
    expect(find.text('«أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ»'), findsOneWidget);
    expect(find.text('فتح المسبحة'), findsOneWidget);
    expect(find.text('1250 مَرَّة'), findsOneWidget);

    await tester.tap(find.byType(MaladhIstighfarCard));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}

