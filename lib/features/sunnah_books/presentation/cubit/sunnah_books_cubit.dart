import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/features/sunnah_books/domain/usecases/get_sunnah_books_usecase.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_state.dart';

class SunnahBooksCubit extends Cubit<SunnahBooksState> {
  final GetSunnahBooksUseCase getBooksUseCase;

  SunnahBooksCubit({required this.getBooksUseCase}) : super(const SunnahBooksInitial());

  Future<void> ensureLoaded() async {
    if (state is SunnahBooksLoaded) return;
    await loadCatalog();
  }

  Future<void> loadCatalog() async {
    if (state is SunnahBooksLoaded) return;

    final result = await getBooksUseCase();
    result.fold(
      (failure) => emit(SunnahBooksError(message: failure.message)),
      (books) {
        emit(
          SunnahBooksLoaded(
            allBooks: books,
            filteredBooks: books,
          ),
        );
      },
    );
  }

  void searchBooks(String query) {
    final current = state;
    if (current is! SunnahBooksLoaded) return;

    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      emit(current.copyWith(
        searchQuery: '',
        filteredBooks: current.allBooks,
      ));
      return;
    }

    final filtered = current.allBooks.where((b) {
      return b.titleAr.toLowerCase().contains(trimmed) ||
          b.titleEn.toLowerCase().contains(trimmed) ||
          b.authorAr.toLowerCase().contains(trimmed);
    }).toList();

    emit(current.copyWith(
      searchQuery: query,
      filteredBooks: filtered,
    ));
  }

  void clearSearch() {
    searchBooks('');
  }
}

