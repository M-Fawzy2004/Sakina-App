import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_action_button.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_indicator.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_page_content.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_skip_button.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/onboarding_screen.dart';

class MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;

  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: child,
      ),
    );
  }

  setUp(() {
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();
    when(() => mockCompleteOnboardingUseCase(const NoParams()))
        .thenAnswer((_) async => const Right(AppRoutes.maladh));

    if (sl.isRegistered<OnboardingCubit>()) {
      sl.unregister<OnboardingCubit>();
    }
    sl.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        completeOnboardingUseCase: mockCompleteOnboardingUseCase,
      ),
    );
  });

  tearDown(() {
    if (sl.isRegistered<OnboardingCubit>()) {
      sl.unregister<OnboardingCubit>();
    }
  });

  group('Onboarding Components Tests', () {
    testWidgets('OnboardingPageContent renders title and subtitle with card',
        (tester) async {
      const item = OnboardingItem(
        index: 0,
        title: 'سَكِينَةُ التِّلَاوَةِ',
        subtitle: 'اسْتَمِعْ لِأَعْذَبِ الحَنَاجِرِ',
        imageAsset: 'assets/images/onboarding_3.png',
        buttonText: 'التَّالِي',
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const Scaffold(
            body: OnboardingPageContent(
              item: item,
              imageHeight: 300,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سَكِينَةُ التِّلَاوَةِ'), findsOneWidget);
      expect(find.text('اسْتَمِعْ لِأَعْذَبِ الحَنَاجِرِ'), findsOneWidget);
    });

    testWidgets('OnboardingIndicator renders active and inactive pills without shadow',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const Scaffold(
            body: OnboardingIndicator(
              count: 3,
              currentIndex: 1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    testWidgets('OnboardingSkipButton renders and triggers callback',
        (tester) async {
      bool skipped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: OnboardingSkipButton(
              onSkip: () => skipped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تَخَطٍّ'), findsOneWidget);
      await tester.tap(find.text('تَخَطٍّ'));
      await tester.pumpAndSettle();

      expect(skipped, isTrue);
    });

    testWidgets('OnboardingActionButton renders and handles tap',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: OnboardingActionButton(
              text: 'التَّالِي',
              isLastPage: false,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التَّالِي'), findsOneWidget);
      await tester.tap(find.text('التَّالِي'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('OnboardingScreen Integration Tests', () {
    testWidgets('renders top step badge, skip button, artwork, and bottom action',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestableWidget(
          const OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top step badge
      expect(find.text('٠١ / ٠٣'), findsOneWidget);
      expect(find.text('تَخَطٍّ'), findsOneWidget);

      // Current page content
      expect(find.text('سَكِينَةُ التِّلَاوَةِ'), findsOneWidget);
      expect(find.text('التَّالِي'), findsOneWidget);

      // Indicator and Action Button
      expect(find.byType(OnboardingIndicator), findsOneWidget);
      expect(find.byType(OnboardingActionButton), findsOneWidget);
    });
  });
}

