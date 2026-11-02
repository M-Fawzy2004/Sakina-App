import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

sealed class HisnState extends Equatable {
  const HisnState();

  @override
  List<Object?> get props => [];
}

final class HisnInitial extends HisnState {
  const HisnInitial();
}

final class HisnLoading extends HisnState {
  const HisnLoading();
}

final class HisnLoaded extends HisnState {
  final List<HisnChapterEntity> allChapters;
  final List<HisnChapterEntity> filteredChapters;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final List<HisnDuaEntity> searchResults;

  const HisnLoaded({
    required this.allChapters,
    required this.filteredChapters,
    required this.categories,
    this.selectedCategory = 'الكل',
    this.searchQuery = '',
    this.searchResults = const [],
  });

  bool get isSearching => searchQuery.trim().isNotEmpty;

  HisnLoaded copyWith({
    List<HisnChapterEntity>? allChapters,
    List<HisnChapterEntity>? filteredChapters,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    List<HisnDuaEntity>? searchResults,
  }) {
    return HisnLoaded(
      allChapters: allChapters ?? this.allChapters,
      filteredChapters: filteredChapters ?? this.filteredChapters,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object?> get props => [
        allChapters,
        filteredChapters,
        categories,
        selectedCategory,
        searchQuery,
        searchResults,
      ];
}

final class HisnError extends HisnState {
  final String message;

  const HisnError({required this.message});

  @override
  List<Object?> get props => [message];
}

