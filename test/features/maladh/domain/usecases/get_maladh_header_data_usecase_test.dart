import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/domain/failures/maladh_failure.dart';
import 'package:sakina_app/features/maladh/domain/repositories/maladh_repository.dart';
import 'package:sakina_app/features/maladh/domain/usecases/get_maladh_header_data_usecase.dart';

class MockMaladhRepository extends Mock implements MaladhRepository {}

void main() {
  late GetMaladhHeaderDataUseCase useCase;
  late MockMaladhRepository mockMaladhRepository;

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
    mockMaladhRepository = MockMaladhRepository();
    useCase = GetMaladhHeaderDataUseCase(repository: mockMaladhRepository);
  });

  test('should return MaladhHeaderData from repository on success', () async {
    when(() => mockMaladhRepository.getHeaderData())
        .thenAnswer((_) async => const Right(testHeaderData));

    final result = await useCase(const NoParams());

    expect(result, const Right(testHeaderData));
    verify(() => mockMaladhRepository.getHeaderData()).called(1);
    verifyNoMoreInteractions(mockMaladhRepository);
  });

  test('should return MaladhHeaderFetchFailure when repository fails', () async {
    when(() => mockMaladhRepository.getHeaderData())
        .thenAnswer((_) async => const Left(MaladhHeaderFetchFailure()));

    final result = await useCase(const NoParams());

    expect(result, isA<Left<Failure, MaladhHeaderData>>());
    verify(() => mockMaladhRepository.getHeaderData()).called(1);
    verifyNoMoreInteractions(mockMaladhRepository);
  });
}

