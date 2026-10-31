import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/failures/quran_failure.dart';
import 'package:sakina_app/features/quran_reading/domain/repositories/quran_repository.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_surahs_usecase.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late GetSurahsUseCase useCase;
  late MockQuranRepository mockRepository;

  setUp(() {
    mockRepository = MockQuranRepository();
    useCase = GetSurahsUseCase(repository: mockRepository);
  });

  const tSurahs = [
    SurahEntity(
      id: 1,
      nameArabic: 'الفَاتِحَة',
      englishName: 'Al-Fatihah',
      revelationType: 'مكية',
      versesCount: 7,
      pageNumber: 1,
      juzNumber: 1,
    ),
    SurahEntity(
      id: 2,
      nameArabic: 'البَقَرَة',
      englishName: 'Al-Baqarah',
      revelationType: 'مدنية',
      versesCount: 286,
      pageNumber: 2,
      juzNumber: 1,
    ),
  ];

  test('should return list of Surahs from repository on success', () async {
    when(() => mockRepository.getSurahs()).thenAnswer((_) async => const Right(tSurahs));

    final result = await useCase(const NoParams());

    expect(result, const Right(tSurahs));
    verify(() => mockRepository.getSurahs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return QuranDataFetchFailure when repository fails', () async {
    const tFailure = QuranDataFetchFailure();
    when(() => mockRepository.getSurahs()).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(const NoParams());

    expect(result, const Left(tFailure));
    verify(() => mockRepository.getSurahs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

