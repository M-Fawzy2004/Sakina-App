import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/usecases/get_hisn_chapters_usecase.dart';
import 'package:sakina_app/features/hisn_muslim/domain/repositories/hisn_repository.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_state.dart';

class HisnCubit extends Cubit<HisnState> {
  final GetHisnChaptersUseCase getChaptersUseCase;
  final HisnRepository repository;

  HisnCubit({
    required this.getChaptersUseCase,
    required this.repository,
  }) : super(const HisnInitial());

  /// Ensures chapters are loaded into memory cache. Direct zero-latency access.
  Future<void> ensureLoaded() async {
    if (state is HisnLoaded) return;
    await loadHisn();
  }

  Future<void> loadHisn() async {
    if (state is HisnLoaded) return;

    final result = await getChaptersUseCase();
    result.fold(
      (failure) => emit(HisnError(message: failure.message)),
      (chapters) {
        final categoriesSet = {'الكل'};
        for (final c in chapters) {
          categoriesSet.add(c.category);
        }

        emit(
          HisnLoaded(
            allChapters: chapters,
            filteredChapters: chapters,
            categories: categoriesSet.toList(),
            selectedCategory: 'الكل',
          ),
        );
      },
    );
  }

  void filterByCategory(String category) {
    final current = state;
    if (current is! HisnLoaded) return;

    final filtered = _applyFilters(
      allChapters: current.allChapters,
      category: category,
      query: current.searchQuery,
    );

    emit(current.copyWith(
      selectedCategory: category,
      filteredChapters: filtered,
    ));
  }

  Future<void> search(String query) async {
    final current = state;
    if (current is! HisnLoaded) return;

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      final filtered = _applyFilters(
        allChapters: current.allChapters,
        category: current.selectedCategory,
        query: '',
      );
      emit(current.copyWith(
        searchQuery: '',
        filteredChapters: filtered,
        searchResults: const [],
      ));
      return;
    }

    final searchResult = await repository.searchDuas(trimmed);
    final results = searchResult.fold((_) => <HisnDuaEntity>[], (r) => r);

    final filtered = _applyFilters(
      allChapters: current.allChapters,
      category: current.selectedCategory,
      query: trimmed,
    );

    emit(current.copyWith(
      searchQuery: query,
      filteredChapters: filtered,
      searchResults: results,
    ));
  }

  void clearSearch() {
    search('');
  }

  List<HisnChapterEntity> _applyFilters({
    required List<HisnChapterEntity> allChapters,
    required String category,
    required String query,
  }) {
    var list = allChapters;
    if (category != 'الكل') {
      list = list.where((c) => c.category == category).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((c) {
        return c.titleAr.toLowerCase().contains(q) ||
            c.title.toLowerCase().contains(q) ||
            c.items.any((dua) =>
                dua.arabic.contains(q) ||
                dua.english.toLowerCase().contains(q));
      }).toList();
    }

    return list;
  }
}
