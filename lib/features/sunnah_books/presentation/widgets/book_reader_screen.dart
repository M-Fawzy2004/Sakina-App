import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/book_reader_state.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/book_reader_top_bar.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/hadith_chapter_bottom_sheet.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/hadith_chapter_chips_row.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/hadith_page_card.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/hadith_search_bar.dart';

class BookReaderScreen extends StatelessWidget {
  final SunnahBookEntity book;
  final int? initialChapterId;

  const BookReaderScreen({
    super.key,
    required this.book,
    this.initialChapterId,
  });

  static Future<void> open(
    BuildContext context,
    SunnahBookEntity book, {
    int? initialChapterId,
  }) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BookReaderScreen(
          book: book,
          initialChapterId: initialChapterId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookReaderCubit>(
      create: (_) => sl<BookReaderCubit>()..initBook(book, initialChapterId: initialChapterId),
      child: _BookReaderView(book: book),
    );
  }
}

class _BookReaderView extends StatefulWidget {
  final SunnahBookEntity book;

  const _BookReaderView({required this.book});

  @override
  State<_BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<_BookReaderView> {
  late final PageController _pageController;
  late final TextEditingController _searchController;
  bool _isSearchOpen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onToggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (!_isSearchOpen) {
        _searchController.clear();
        context.read<BookReaderCubit>().clearSearch();
      }
    });
  }

  void _openChaptersBottomSheet(BuildContext context, int? selectedChapterId) {
    HadithChapterBottomSheet.show(
      context,
      chapters: widget.book.chapters,
      selectedChapterId: selectedChapterId,
      onChapterSelected: (chapterId) {
        context.read<BookReaderCubit>().selectChapter(chapterId);
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      },
    );
  }

  void _onChapterSelected(int? chapterId) {
    context.read<BookReaderCubit>().selectChapter(chapterId);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _goToPrevious() {
    if (_pageController.hasClients && _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToNext(int totalLoaded) {
    if (_pageController.hasClients && _pageController.page! < totalLoaded - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<BookReaderCubit>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<BookReaderCubit, BookReaderState>(
          listener: (context, state) {
            if (state is BookReaderLoaded && state.currentHadithIndex == 0) {
              if (_pageController.hasClients && _pageController.page != 0) {
                _pageController.jumpToPage(0);
              }
            }
          },
          builder: (context, state) {
            if (state is BookReaderLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: colors.accentGold,
                  strokeWidth: 2.5,
                ),
              );
            }

            if (state is BookReaderError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    ElevatedButton(
                      onPressed: () => cubit.initBook(widget.book),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is BookReaderLoaded) {
              final activeChapter = state.selectedChapterId != null
                  ? widget.book.chapters.firstWhere(
                      (c) => c.id == state.selectedChapterId,
                      orElse: () => widget.book.chapters.first,
                    )
                  : null;

              final subtitle = activeChapter != null
                  ? activeChapter.arabic
                  : 'حديث (${state.totalCount} شريف)';

              return Column(
                children: [
                  // 1. Fixed Top Bar (Back button never scrolls away)
                  BookReaderTopBar(
                    titleAr: widget.book.titleAr,
                    subtitle: subtitle,
                    isSearchOpen: _isSearchOpen,
                    onToggleSearch: _onToggleSearch,
                    onOpenChapters: () => _openChaptersBottomSheet(context, state.selectedChapterId),
                  ),

                  // 2. Search Field when toggled
                  if (_isSearchOpen)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                      child: HadithSearchBar(
                        controller: _searchController,
                        hasActiveChapter: state.selectedChapterId != null && state.selectedChapterId! > 0,
                        onChanged: (val) => cubit.searchHadiths(val),
                        onClear: () {
                          _searchController.clear();
                          cubit.clearSearch();
                        },
                        onFilterTap: () => _openChaptersBottomSheet(context, state.selectedChapterId),
                      ),
                    ),

                  // 3. Category/Chapter Chips Row directly under search
                  HadithChapterChipsRow(
                    chapters: widget.book.chapters,
                    selectedChapterId: state.selectedChapterId,
                    onChapterSelected: _onChapterSelected,
                  ),

                  // 4. Subtle filtering indicator
                  if (state.isFiltering)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: LinearProgressIndicator(
                        minHeight: 2.h,
                        color: colors.accentGold,
                        backgroundColor: colors.surfaceElevated,
                      ),
                    )
                  else
                    SizedBox(height: 6.h),

                  // 5. Main Content: Horizontal PageView
                  Expanded(
                    child: state.hadiths.isEmpty
                        ? const _EmptyHadithCard()
                        : PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.hadiths.length,
                            onPageChanged: cubit.onHadithPageChanged,
                            itemBuilder: (context, index) {
                              final hadith = state.hadiths[index];
                              final chapter = widget.book.chapters.where((c) => c.id == hadith.chapterId).firstOrNull;

                              return HadithPageCard(
                                hadith: hadith,
                                bookTitle: widget.book.titleAr,
                                chapterTitle: chapter?.arabic,
                                currentIndex: index,
                                totalCount: state.totalCount,
                                onPrevious: index > 0 ? _goToPrevious : null,
                                onNext: index < state.hadiths.length - 1
                                    ? () => _goToNext(state.hadiths.length)
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EmptyHadithCard extends StatelessWidget {
  const _EmptyHadithCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 48.r,
            color: colors.textSecondary.withValues(alpha: 0.4),
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد أحاديث مطابقة للبحث أو الباب المختار',
            style: AppTextStyles.bodyMediumOf(context).copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
