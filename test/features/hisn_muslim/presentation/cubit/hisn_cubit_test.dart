import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';
import 'package:sakina_app/features/hisn_muslim/domain/usecases/get_hisn_chapters_usecase.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_cubit.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_state.dart';

class MockGetHisnChaptersUseCase extends Mock
    implements GetHisnChaptersUseCase {}

class MockHisnRepository extends Mock implements HisnRepository {}

void main() {
  late MockGetHisnChaptersUseCase mockGetChaptersUseCase;
  late MockHisnRepository mockRepository;
  late HisnCubit cubit;

  const testDua1 = HisnDuaEntity(
    id: 1,
    chapterId: 1,
    chapterTitle: 'Chapter: When waking up',
    chapterTitleAr: 'أذكار الاستيقاظ من النوم',
    reference: 'Reference: Hisn al-Muslim 1',
    arabic: 'الحمد لله الذي أحيانا',
    english: 'Praise is to Allah',
  );

  const testDua2 = HisnDuaEntity(
    id: 2,
    chapterId: 2,
    chapterTitle: 'Chapter: Before sleeping',
    chapterTitleAr: 'أذكار النوم',
    reference: 'Reference: Hisn al-Muslim 2',
    arabic: 'باسمك ربي وضعت جنبي',
    english: 'In Your name my Lord',
  );

  const testChapters = [
    HisnChapterEntity(
      id: 1,
      title: 'Chapter: When waking up',
      titleAr: 'أذكار الاستيقاظ من النوم',
      category: 'اليوم والليلة',
      items: [testDua1],
    ),
    HisnChapterEntity(
      id: 2,
      title: 'Chapter: Before sleeping',
      titleAr: 'أذكار النوم',
      category: 'اليوم والليلة',
      items: [testDua2],
    ),
  ];

  setUp(() {
    mockGetChaptersUseCase = MockGetHisnChaptersUseCase();
    mockRepository = MockHisnRepository();
    cubit = HisnCubit(
      getChaptersUseCase: mockGetChaptersUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('HisnCubit Tests', () {
    test('initial state should be HisnInitial', () {
      expect(cubit.state, const HisnInitial());
    });

    test('ensureLoaded loads hisn if not yet loaded', () async {
      when(() => mockGetChaptersUseCase())
          .thenAnswer((_) async => const Right(testChapters));

      await cubit.ensureLoaded();

      expect(cubit.state, isA<HisnLoaded>());
    });

    test('loadHisn emits HisnLoaded on success', () async {
      when(() => mockGetChaptersUseCase())
          .thenAnswer((_) async => const Right(testChapters));

      await cubit.loadHisn();

      expect(cubit.state, isA<HisnLoaded>());
      final loaded = cubit.state as HisnLoaded;
      expect(loaded.allChapters.length, 2);
      expect(loaded.categories, contains('اليوم والليلة'));
    });

    test('loadHisn emits HisnError on failure', () async {
      when(() => mockGetChaptersUseCase())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'خطأ تحميل')));

      await cubit.loadHisn();

      expect(cubit.state, const HisnError(message: 'خطأ تحميل'));
    });

    test('filterByCategory filters chapters correctly', () async {
      when(() => mockGetChaptersUseCase())
          .thenAnswer((_) async => const Right(testChapters));

      await cubit.loadHisn();
      cubit.filterByCategory('اليوم والليلة');

      final loaded = cubit.state as HisnLoaded;
      expect(loaded.selectedCategory, 'اليوم والليلة');
      expect(loaded.filteredChapters.length, 2);
    });

    test('search finds matching chapters and duas', () async {
      when(() => mockGetChaptersUseCase())
          .thenAnswer((_) async => const Right(testChapters));
      when(() => mockRepository.searchDuas('استيقاظ'))
          .thenAnswer((_) async => const Right([testDua1]));

      await cubit.loadHisn();
      await cubit.search('استيقاظ');

      final loaded = cubit.state as HisnLoaded;
      expect(loaded.searchResults.length, 1);
      expect(loaded.filteredChapters.length, 1);
    });
  });
}

