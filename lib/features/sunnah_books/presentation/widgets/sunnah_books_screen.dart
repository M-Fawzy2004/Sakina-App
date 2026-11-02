import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_cubit.dart';
import 'package:sakina_app/features/sunnah_books/presentation/cubit/sunnah_books_state.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/book_reader_screen.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/sunnah_book_card.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/sunnah_books_header.dart';
import 'package:sakina_app/features/sunnah_books/presentation/widgets/components/sunnah_books_stats_ribbon.dart';

class SunnahBooksScreen extends StatelessWidget {
  const SunnahBooksScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const SunnahBooksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SunnahBooksCubit>.value(
      value: sl<SunnahBooksCubit>()..ensureLoaded(),
      child: const _SunnahBooksView(),
    );
  }
}

class _SunnahBooksView extends StatefulWidget {
  const _SunnahBooksView();

  @override
  State<_SunnahBooksView> createState() => _SunnahBooksViewState();
}

class _SunnahBooksViewState extends State<_SunnahBooksView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<SunnahBooksCubit>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<SunnahBooksCubit, SunnahBooksState>(
          builder: (context, state) {
            if (state is SunnahBooksError) {
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
                      onPressed: () => cubit.loadCatalog(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is SunnahBooksLoaded) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // 1. Header
                  SliverToBoxAdapter(
                    child: SunnahBooksHeader(
                      onBackTap: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // 2. Stats & Prophetic Quote Ribbon
                  SliverToBoxAdapter(
                    child: SunnahBooksStatsRibbon(
                      totalBooks: state.allBooks.length,
                      totalChapters: state.totalChapters,
                      totalHadiths: state.totalHadiths,
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 14.h)),

                  // 3. Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: colors.cardSurface,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: colors.borderHairline,
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12.w),
                            Icon(
                              Iconsax.search_normal_1,
                              size: 17.r,
                              color: colors.textSecondary,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) => cubit.searchBooks(val),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textPrimary,
                                  fontSize: 12.5.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'ابحث في أسماء كتب ومصنفات السنة...',
                                  hintStyle: AppTextStyles.captionOf(context).copyWith(
                                    color: colors.textSecondary,
                                    fontSize: 11.5.sp,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              IconButton(
                                icon: Icon(
                                  Iconsax.close_circle,
                                  size: 16.r,
                                  color: colors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  cubit.clearSearch();
                                },
                              )
                            else
                              SizedBox(width: 10.w),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                  // 4. Books List
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final book = state.filteredBooks[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: SunnahBookCard(
                              book: book,
                              onTap: () => _openBook(context, book),
                            ),
                          );
                        },
                        childCount: state.filteredBooks.length,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(height: 32.h),
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

  void _openBook(BuildContext context, SunnahBookEntity book) {
    BookReaderScreen.open(context, book);
  }
}

