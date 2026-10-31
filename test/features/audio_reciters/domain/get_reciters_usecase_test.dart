import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/repositories/audio_reciters_repository.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_featured_reciter_usecase.dart';
import 'package:sakina_app/features/audio_reciters/domain/usecases/get_reciters_usecase.dart';
import 'package:sakina_app/core/usecases/usecase.dart';

class MockAudioRecitersRepository extends Mock implements AudioRecitersRepository {}

void main() {
  late MockAudioRecitersRepository mockRepository;
  late GetRecitersUseCase getRecitersUseCase;
  late GetFeaturedReciterUseCase getFeaturedReciterUseCase;

  setUp(() {
    mockRepository = MockAudioRecitersRepository();
    getRecitersUseCase = GetRecitersUseCase(repository: mockRepository);
    getFeaturedReciterUseCase = GetFeaturedReciterUseCase(repository: mockRepository);
  });

  const testReciter = ReciterEntity(
    id: 1,
    nameArabic: 'الشيخ عبد الباسط عبد الصمد',
    englishName: 'Abdul Basit Abdul Samad',
    photoUrl: 'https://example.com/photo.jpg',
    listenersCount: 1578,
    formattedListeners: '1,578',
    revelationStyle: 'تلاوة خاشعة',
    riwayah: 'حفص عن عاصم',
    isFeatured: true,
    availableSurahsCount: 114,
    categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
  );

  group('GetRecitersUseCase', () {
    test('returns List<ReciterEntity> when repository succeeds', () async {
      when(() => mockRepository.getReciters(
            category: any(named: 'category'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => const Right([testReciter]));

      final result = await getRecitersUseCase(
        const GetRecitersParams(category: 'الأكثر استماعاً'),
      );

      expect(result, const Right([testReciter]));
      verify(() => mockRepository.getReciters(category: 'الأكثر استماعاً', query: null)).called(1);
    });

    test('returns CacheFailure when repository fails', () async {
      when(() => mockRepository.getReciters(
            category: any(named: 'category'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => const Left(CacheFailure(message: 'خطأ')));

      final result = await getRecitersUseCase(const GetRecitersParams());

      expect(result, const Left(CacheFailure(message: 'خطأ')));
    });
  });

  group('GetFeaturedReciterUseCase', () {
    test('returns featured reciters list successfully', () async {
      when(() => mockRepository.getFeaturedReciters())
          .thenAnswer((_) async => const Right([testReciter]));

      final result = await getFeaturedReciterUseCase(const NoParams());

      expect(result, const Right([testReciter]));
      verify(() => mockRepository.getFeaturedReciters()).called(1);
    });
  });
}

