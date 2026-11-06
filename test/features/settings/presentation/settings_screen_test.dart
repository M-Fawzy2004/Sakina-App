import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:sakina_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/widgets/settings_screen.dart';
import 'package:sakina_app/features/settings/presentation/widgets/theme_selector_screen.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}
class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}
class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockPreferencesService extends Mock implements PreferencesService {}
class MockQuranCubit extends Mock implements QuranCubit {}

void main() {
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;
  late MockSettingsRepository mockSettingsRepository;
  late MockPreferencesService mockPreferencesService;
  late MockQuranCubit mockQuranCubit;
  late SettingsCubit cubit;

  setUpAll(() {
    registerFallbackValue(const SetThemeModeParams(mode: AppThemeMode.light));
    registerFallbackValue(const NoParams());
    registerFallbackValue(const Color(0xFF10B981));
  });

  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();
    mockSettingsRepository = MockSettingsRepository();
    mockPreferencesService = MockPreferencesService();
    mockQuranCubit = MockQuranCubit();

    when(() => mockQuranCubit.state).thenReturn(const QuranInitial());
    when(() => mockQuranCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockQuranCubit.close()).thenAnswer((_) async {});

    when(() => mockPreferencesService.getString(any())).thenReturn(null);
    when(() => mockPreferencesService.getBool(any())).thenReturn(null);
    when(() => mockPreferencesService.getInt(any())).thenReturn(null);
    when(() => mockPreferencesService.getDouble(any())).thenReturn(null);
    when(() => mockPreferencesService.setString(any(), any()))
        .thenAnswer((_) async => true);
    when(() => mockPreferencesService.setBool(any(), any()))
        .thenAnswer((_) async => true);

    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
    GetIt.I.registerSingleton<PreferencesService>(mockPreferencesService);

    if (GetIt.I.isRegistered<QuranCubit>()) {
      GetIt.I.unregister<QuranCubit>();
    }
    GetIt.I.registerSingleton<QuranCubit>(mockQuranCubit);

    when(() => mockSetThemeModeUseCase(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => mockSettingsRepository.setPrimaryAccentColor(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => mockSettingsRepository.resetSettings())
        .thenAnswer((_) async => const Right(null));

    cubit = SettingsCubit(
      getThemeModeUseCase: mockGetThemeModeUseCase,
      setThemeModeUseCase: mockSetThemeModeUseCase,
      repository: mockSettingsRepository,
    );
  });

  tearDown(() {
    cubit.close();
    if (GetIt.I.isRegistered<PreferencesService>()) {
      GetIt.I.unregister<PreferencesService>();
    }
    if (GetIt.I.isRegistered<QuranCubit>()) {
      GetIt.I.unregister<QuranCubit>();
    }
  });

  Widget buildTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: cubit),
          BlocProvider<QuranCubit>.value(value: mockQuranCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: child,
        ),
      ),
    );
  }

  group('SettingsScreen Widget Tests', () {
    testWidgets('renders all redesigned sections, appearance hero gateway, and reset card', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('سَكِينَةُ'), findsOneWidget);
      expect(find.text('الإِعْدَادَاتُ العَامَّةُ'), findsOneWidget);
      expect(find.text('وَاحَةُ سَكِينَةَ المُبَارَكَةُ'), findsOneWidget);
      expect(find.text('المَظْهَرُ وَالثِّيمَاتُ وَالأَلْوَانُ'), findsOneWidget);
      expect(find.text('تَفْضِيلَاتُ المَصْحَفِ وَالقِرَاءَةِ'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('الصَّوْتِيَّاتُ وَالتِّلَاوَةُ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('الصَّوْتِيَّاتُ وَالتِّلَاوَةُ'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('التَّذْكِيرَاتُ وَالوِرْدُ اليَوْمِيُّ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('التَّذْكِيرَاتُ وَالوِرْدُ اليَوْمِيُّ'), findsOneWidget);
      expect(find.text('تَنْبِيهَاتُ الصَّلَوَاتِ (قَبْلَ الأَذَانِ بِـ ٥ دَقَائِق)'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('الأَمَانُ وَخُصُوصِيَّةُ الإِنَابَةِ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('الأَمَانُ وَخُصُوصِيَّةُ الإِنَابَةِ'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('التَّخْزِينُ وَالذَّاكِرَةُ المُؤَقَّتَةُ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('التَّخْزِينُ وَالذَّاكِرَةُ المُؤَقَّتَةُ'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('عَنْ سَكِينَةَ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('عَنْ سَكِينَةَ'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('اسْتِعَادَةُ الإِعْدَادَاتِ الاِفْتِرَاضِيَّةِ'), 150.0);
      await tester.pumpAndSettle();
      expect(find.text('اسْتِعَادَةُ الإِعْدَادَاتِ الاِفْتِرَاضِيَّةِ'), findsOneWidget);
    });
  });

  group('ThemeSelectorScreen Widget Tests', () {
    testWidgets('renders jewel accent colors and large theme preview cards', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget(const ThemeSelectorScreen()));
      await tester.pumpAndSettle();

      expect(find.text('المَظْهَرُ وَالأَلْوَانُ'), findsOneWidget);
      expect(find.textContaining('Primary Accent'), findsOneWidget);
      expect(find.text('ثِيمَاتُ المَصْحَفِ الشَّرِيفِ'), findsOneWidget);
      expect(find.text('الافتراضي'), findsOneWidget);

      // Verify first theme card title
      expect(find.text('الفَحْمِيُّ الحَدِيثُ'), findsOneWidget);
      expect(find.text('الَّليْلُ المَلَكِيُّ'), findsOneWidget);

      // Scroll down to reveal Emerald and subsequent cards
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('زُمُرُّدُ الفِرْدَوْسِ'), findsOneWidget);
      expect(find.text('رَقُّ السَّكِينَةِ'), findsOneWidget);
      expect(find.text('تِلْقَائِيُّ النِّظَامِ'), findsOneWidget);

      // Tap on Emerald Theme Card
      await tester.tap(find.text('زُمُرُّدُ الفِرْدَوْسِ'));
      await tester.pumpAndSettle();

      expect(cubit.state.appThemeMode, equals(AppThemeMode.emerald));
    });
  });
}
