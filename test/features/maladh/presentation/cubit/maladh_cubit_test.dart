import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/domain/failures/maladh_failure.dart';
import 'package:sakina_app/features/maladh/domain/usecases/get_maladh_header_data_usecase.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_cubit.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_state.dart';

class MockGetMaladhHeaderDataUseCase extends Mock implements GetMaladhHeaderDataUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MaladhCubit cubit;
  late MockGetMaladhHeaderDataUseCase mockUseCase;

  const testHeaderData = MaladhHeaderData(
    greetingTitle: 'صَبَاحُ السَّكِينَةِ وَالطُّمَأْنِينَةِ',
    greetingSubtitle: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
    hijriDate: '١٥ شَعْبَان ١٤٤٧ هـ',
    gregorianDate: 'الجُمُعَة، ٣٠ أُكْتُوبِر',
    dailyVerseText: '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
    dailyVerseSurah: 'سُورَةُ الرَّعْدِ • آيَة ٢٨',
    nextPrayerName: 'الظُّهْرُ',
    nextPrayerTimeRemaining: 'بَعْدَ ٤٥ دَقِيقَة',
    streakDays: 3,
  );

  setUp(() {
    mockUseCase = MockGetMaladhHeaderDataUseCase();
    cubit = MaladhCubit(getMaladhHeaderDataUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be MaladhInitial', () {
    expect(cubit.state, const MaladhInitial());
  });

  test('loadSanctuaryData should emit [MaladhLoading, MaladhLoaded] when usecase succeeds', () async {
    when(() => mockUseCase(const NoParams()))
        .thenAnswer((_) async => const Right(testHeaderData));

    final expectedStates = [
      const MaladhLoading(),
      const MaladhLoaded(headerData: testHeaderData),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadSanctuaryData();
    verify(() => mockUseCase(const NoParams())).called(1);
  });

  test('loadSanctuaryData should emit [MaladhLoading, MaladhError] when usecase fails', () async {
    when(() => mockUseCase(const NoParams()))
        .thenAnswer((_) async => const Left(MaladhHeaderFetchFailure(message: 'خطأ في الاتصال')));

    final expectedStates = [
      const MaladhLoading(),
      const MaladhError(message: 'خطأ في الاتصال'),
    ];

    expectLater(cubit.stream, emitsInOrder(expectedStates));

    await cubit.loadSanctuaryData();
    verify(() => mockUseCase(const NoParams())).called(1);
  });
}

