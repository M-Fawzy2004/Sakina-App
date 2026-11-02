import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_book_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/search_hadiths_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_state.dart';

class BookReaderCubit extends Cubit<BookReaderState> {
  final GetBookHadithsUseCase getHadithsUseCase;
  final SearchHadithsUseCase searchHadithsUseCase;

  static const int kPageSize = 20;

  BookReaderCubit({
    required this.getHadithsUseCase,
    required this.searchHadithsUseCase,
  }) : super(const BookReaderInitial());

  Future<void> initBook(SunnahBookEntity book, {int? initialChapterId}) async {
    // If not already loaded, emit loading briefly
    if (state is! BookReaderLoaded) {
      emit(const BookReaderLoading());
    }

    final result = await getHadithsUseCase(
      bookKey: book.key,
      chapterId: initialChapterId,
      page: 1,
      pageSize: kPageSize,
    );

    result.fold(
      (failure) => emit(BookReaderError(message: failure.message)),
      (pageData) {
        emit(
          BookReaderLoaded(
            book: book,
            hadiths: pageData.hadiths,
            currentPage: 1,
            totalCount: pageData.totalCount,
            hasMore: pageData.hasMore,
            selectedChapterId: initialChapterId,
            currentHadithIndex: 0,
          ),
        );
      },
    );
  }

  void onHadithPageChanged(int index) {
    final current = state;
    if (current is! BookReaderLoaded) return;

    emit(current.copyWith(currentHadithIndex: index));

    // When swiping near the end of loaded hadiths, automatically trigger next page
    if (index >= current.hadiths.length - 5 && current.hasMore && !current.isLoadingMore) {
      loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    final current = state;
    if (current is! BookReaderLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;

    if (current.isSearching) {
      final result = await searchHadithsUseCase(
        bookKey: current.book.key,
        query: current.searchQuery,
        page: nextPage,
        pageSize: kPageSize,
      );

      result.fold(
        (failure) => emit(current.copyWith(isLoadingMore: false)),
        (pageData) {
          final updated = List<HadithEntity>.from(current.hadiths)..addAll(pageData.hadiths);
          emit(
            current.copyWith(
              hadiths: updated,
              currentPage: nextPage,
              hasMore: pageData.hasMore,
              isLoadingMore: false,
            ),
          );
        },
      );
    } else {
      final result = await getHadithsUseCase(
        bookKey: current.book.key,
        chapterId: current.selectedChapterId,
        page: nextPage,
        pageSize: kPageSize,
      );

      result.fold(
        (failure) => emit(current.copyWith(isLoadingMore: false)),
        (pageData) {
          final updated = List<HadithEntity>.from(current.hadiths)..addAll(pageData.hadiths);
          emit(
            current.copyWith(
              hadiths: updated,
              currentPage: nextPage,
              hasMore: pageData.hasMore,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  Future<void> selectChapter(int? chapterId) async {
    final current = state;
    if (current is! BookReaderLoaded) return;
    if (current.selectedChapterId == chapterId && !current.isSearching) return;

    emit(current.copyWith(isFiltering: true));

    final result = await getHadithsUseCase(
      bookKey: current.book.key,
      chapterId: chapterId,
      page: 1,
      pageSize: kPageSize,
    );

    result.fold(
      (failure) => emit(BookReaderError(message: failure.message)),
      (pageData) {
        emit(
          current.copyWith(
            hadiths: pageData.hadiths,
            currentPage: 1,
            totalCount: pageData.totalCount,
            hasMore: pageData.hasMore,
            selectedChapterId: chapterId,
            clearChapter: chapterId == null,
            searchQuery: '',
            isFiltering: false,
            currentHadithIndex: 0,
          ),
        );
      },
    );
  }

  Future<void> searchHadiths(String query) async {
    final current = state;
    if (current is! BookReaderLoaded) return;

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      await selectChapter(current.selectedChapterId);
      return;
    }

    emit(current.copyWith(isFiltering: true));

    final result = await searchHadithsUseCase(
      bookKey: current.book.key,
      query: trimmed,
      page: 1,
      pageSize: kPageSize,
    );

    result.fold(
      (failure) => emit(BookReaderError(message: failure.message)),
      (pageData) {
        emit(
          current.copyWith(
            hadiths: pageData.hadiths,
            currentPage: 1,
            totalCount: pageData.totalCount,
            hasMore: pageData.hasMore,
            searchQuery: query,
            isFiltering: false,
            currentHadithIndex: 0,
          ),
        );
      },
    );
  }

  void clearSearch() {
    searchHadiths('');
  }
}
