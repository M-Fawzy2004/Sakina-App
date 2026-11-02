import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

sealed class BookReaderState extends Equatable {
  const BookReaderState();

  @override
  List<Object?> get props => [];
}

final class BookReaderInitial extends BookReaderState {
  const BookReaderInitial();
}

final class BookReaderLoading extends BookReaderState {
  const BookReaderLoading();
}

final class BookReaderLoaded extends BookReaderState {
  final SunnahBookEntity book;
  final List<HadithEntity> hadiths;
  final int currentPage;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isFiltering;
  final int? selectedChapterId;
  final String searchQuery;
  final int currentHadithIndex;

  const BookReaderLoaded({
    required this.book,
    required this.hadiths,
    required this.currentPage,
    required this.totalCount,
    required this.hasMore,
    this.isLoadingMore = false,
    this.isFiltering = false,
    this.selectedChapterId,
    this.searchQuery = '',
    this.currentHadithIndex = 0,
  });

  bool get isFilteringByChapter => selectedChapterId != null && selectedChapterId! > 0;
  bool get isSearching => searchQuery.trim().isNotEmpty;

  BookReaderLoaded copyWith({
    SunnahBookEntity? book,
    List<HadithEntity>? hadiths,
    int? currentPage,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isFiltering,
    int? selectedChapterId,
    bool clearChapter = false,
    String? searchQuery,
    int? currentHadithIndex,
  }) {
    return BookReaderLoaded(
      book: book ?? this.book,
      hadiths: hadiths ?? this.hadiths,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isFiltering: isFiltering ?? this.isFiltering,
      selectedChapterId: clearChapter ? null : (selectedChapterId ?? this.selectedChapterId),
      searchQuery: searchQuery ?? this.searchQuery,
      currentHadithIndex: currentHadithIndex ?? this.currentHadithIndex,
    );
  }

  @override
  List<Object?> get props => [
        book,
        hadiths,
        currentPage,
        totalCount,
        hasMore,
        isLoadingMore,
        isFiltering,
        selectedChapterId,
        searchQuery,
        currentHadithIndex,
      ];
}

final class BookReaderError extends BookReaderState {
  final String message;

  const BookReaderError({required this.message});

  @override
  List<Object?> get props => [message];
}
