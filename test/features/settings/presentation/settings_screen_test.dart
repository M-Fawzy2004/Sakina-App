import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
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

void main() {
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;
  late MockSettingsRepository mockSettingsRepository;
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
  });

  Widget buildTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => BlocProvider<SettingsCubit>.value(
        value: cubit,
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
      expect(find.text('المَظْهَرُ وَالثِّيمَاتُ وَالأَلْوَانُ'), findsOneWidget);
      expect(find.text('تَفْضِيلَاتُ المَصْحَفِ وَالقِرَاءَةِ'), findsOneWidget);
      expect(find.text('الصَّوْتِيَّاتُ وَالتِّلَاوَةُ'), findsOneWidget);

      // Scroll down to reveal remaining sections
      await tester.scrollUntilVisible(
        find.text('عَنْ سَكِينَةَ'),
        300.0,
      );
      await tester.pumpAndSettle();

      expect(find.text('التَّذْكِيرَاتُ وَالوِرْدُ اليَوْمِيُّ'), findsOneWidget);
      expect(find.text('اسْتِعَادَةُ الإِعْدَادَاتِ الاِفْتِرَاضِيَّةِ'), findsOneWidget);
      expect(find.text('عَنْ سَكِينَةَ'), findsOneWidget);
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
