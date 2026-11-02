import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

sealed class SunnahBooksState extends Equatable {
  const SunnahBooksState();

  @override
  List<Object?> get props => [];
}

final class SunnahBooksInitial extends SunnahBooksState {
  const SunnahBooksInitial();
}

final class SunnahBooksLoading extends SunnahBooksState {
  const SunnahBooksLoading();
}

final class SunnahBooksLoaded extends SunnahBooksState {
  final List<SunnahBookEntity> allBooks;
  final List<SunnahBookEntity> filteredBooks;
  final String searchQuery;

  const SunnahBooksLoaded({
    required this.allBooks,
    required this.filteredBooks,
    this.searchQuery = '',
  });

  int get totalHadiths => allBooks.fold(0, (sum, b) => sum + b.hadithsCount);
  int get totalChapters => allBooks.fold(0, (sum, b) => sum + b.chaptersCount);

  SunnahBooksLoaded copyWith({
    List<SunnahBookEntity>? allBooks,
    List<SunnahBookEntity>? filteredBooks,
    String? searchQuery,
  }) {
    return SunnahBooksLoaded(
      allBooks: allBooks ?? this.allBooks,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allBooks, filteredBooks, searchQuery];
}

final class SunnahBooksError extends SunnahBooksState {
  final String message;

  const SunnahBooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

