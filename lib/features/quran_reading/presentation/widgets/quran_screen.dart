import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/hizb_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_bookmarks_view.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_hizbs_list.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_juzs_list.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_mushaf_brand_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_pages_list.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_resume_reading_hero.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_search_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_shimmer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surahs_list.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tab_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/surah_reader_screen.dart';

/// The Master Holy Quran Sanctuary Screen («القُرْآنُ الكَرِيمُ»).
/// Unified scrollable architecture delivering an organic, seamless experience:
/// 1. Symmetric Brand Header with Crescent & Calligraphy
/// 2. Resume Reading Hero Card with Silk Bookmark Ribbon
/// 3. Tab Navigation (Pages, Surahs, Juzs, Hizbs)
/// 4. Opening any Surah opens a dedicated full-screen reader above bottom navigation
/// 5. Entire screen scrolls fluidly via CustomScrollView & Slivers
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuranCubit>(
      create: (_) => sl<QuranCubit>()..loadQuranData(),
      child: const _QuranScreenContent(),
    );
  }
}

class _QuranScreenContent extends StatelessWidget {
  const _QuranScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            return switch (state) {
              QuranInitial() || QuranLoading() => const QuranShimmer(),
              QuranError(:final message) => _QuranErrorView(
                  message: message,
                  onRetry: () => context.read<QuranCubit>().loadQuranData(),
                ),
              QuranLoaded() => _QuranCatalogBody(state: state),
            };
          },
        ),
      ),
    );
  }
}

/// The sanctuary catalog body where the whole screen scrolls seamlessly.
class _QuranCatalogBody extends StatefulWidget {
  final QuranLoaded state;

  const _QuranCatalogBody({required this.state});

  @override
  State<_QuranCatalogBody> createState() => _QuranCatalogBodyState();
}

class _QuranCatalogBodyState extends State<_QuranCatalogBody> {
  bool _isSearchVisible = false;

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        context.read<QuranCubit>().searchSurahs('');
      }
    });
  }

  void _navigateToSurah(
    SurahEntity surah, {
    int? initialAyahNumber,
    int? initialPageNumber,
  }) {
    SurahReaderScreen.open(
      context,
      surah,
      initialAyahNumber: initialAyahNumber,
      initialPageNumber: initialPageNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranCubit>();
    final showSearch = _isSearchVisible || widget.state.searchQuery.isNotEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // 1. Top Brand Sanctuary Header («القُرْآنُ الكَرِيمُ»)
        SliverToBoxAdapter(
          child: QuranMushafBrandHeader(
            isSearchActive: showSearch,
            onSearchToggle: _toggleSearch,
          ),
        ),

        // 2. Search Bar (Mounted cleanly right under the header when active)
        if (showSearch)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: QuranSearchBar(
                currentQuery: widget.state.searchQuery,
                onChanged: (query) => cubit.searchSurahs(query),
              ),
            ),
          ),

        // 3. Resume Reading Hero Card (Displayed in normal catalog mode)
        if (!showSearch)
          SliverToBoxAdapter(
            child: QuranResumeReadingHero(
              bookmark: widget.state.lastReadBookmark,
              onResumeTap: () {
                final targetSurahId =
                    widget.state.lastReadBookmark?.surahId ?? 18;
                final targetSurah = widget.state.allSurahs.firstWhere(
                  (s) => s.id == targetSurahId,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(
                  targetSurah,
                  initialAyahNumber: widget.state.lastReadBookmark?.ayahNumber,
                  initialPageNumber: widget.state.lastReadBookmark?.pageNumber,
                );
              },
            ),
          ),

        // 4. Tab Bar (Page, Surah, Juz, Hizb)
        if (!showSearch)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: QuranTabBar(
                selectedTab: widget.state.selectedTab,
                onTabSelected: (tab) => cubit.selectTab(tab),
              ),
            ),
          ),

        // 5. Active Tab View Content as Slivers
        if (showSearch)
          QuranSurahsList(
            surahs: widget.state.filteredSurahs,
            onSurahTap: (surah) => _navigateToSurah(surah),
          )
        else
          switch (widget.state.selectedTab) {
            QuranTab.surahs => QuranSurahsList(
                surahs: widget.state.filteredSurahs,
                onSurahTap: (surah) => _navigateToSurah(surah),
              ),
            QuranTab.juzs => QuranJuzsList(
                juzs: widget.state.juzs,
                allSurahs: widget.state.allSurahs,
                onJuzTap: (juz) {
                  final targetSurah = widget.state.allSurahs.firstWhere(
                    (s) => s.nameArabic == juz.startSurahName,
                    orElse: () => widget.state.allSurahs.first,
                  );
                  _navigateToSurah(
                    targetSurah,
                    initialAyahNumber: juz.startVerseNumber,
                    initialPageNumber: juz.startPageNumber,
                  );
                },
              ),
            QuranTab.page => QuranPagesList(
                allSurahs: widget.state.allSurahs,
                onPageTap: (pageNumber) {
                  final targetSurah = widget.state.allSurahs.lastWhere(
                    (s) => s.pageNumber <= pageNumber,
                    orElse: () => widget.state.allSurahs.first,
                  );
                  final matchingHizb = HizbEntity.allHizbs.firstWhere(
                    (h) => h.startPageNumber == pageNumber,
                    orElse: () => const HizbEntity(
                      number: 0,
                      juzNumber: 0,
                      surahId: 0,
                      surahName: '',
                      startVerseNumber: 0,
                      startPageNumber: 0,
                      quarterTitle: '',
                    ),
                  );

                  final initialAyah = matchingHizb.startVerseNumber > 0
                      ? matchingHizb.startVerseNumber
                      : (pageNumber == targetSurah.pageNumber ? 1 : null);

                  _navigateToSurah(
                    targetSurah,
                    initialAyahNumber: initialAyah,
                    initialPageNumber: pageNumber,
                  );
                },
              ),
            QuranTab.hizbs => QuranHizbsList(
                allSurahs: widget.state.allSurahs,
                onHizbTap: (hizb) {
                  final targetSurah = widget.state.allSurahs.firstWhere(
                    (s) => s.id == hizb.surahId,
                    orElse: () => widget.state.allSurahs.firstWhere(
                      (s) => s.nameArabic == hizb.surahName,
                      orElse: () => widget.state.allSurahs.first,
                    ),
                  );
                  _navigateToSurah(
                    targetSurah,
                    initialAyahNumber: hizb.startVerseNumber,
                    initialPageNumber: hizb.startPageNumber,
                  );
                },
              ),
            QuranTab.bookmarks => SliverToBoxAdapter(
                child: QuranBookmarksView(
                  lastReadBookmark: widget.state.lastReadBookmark,
                  onBookmarkTap: (bookmark) {
                    final targetSurah = widget.state.allSurahs.firstWhere(
                      (s) => s.id == bookmark.surahId,
                      orElse: () => widget.state.allSurahs.first,
                    );
                    _navigateToSurah(
                      targetSurah,
                      initialAyahNumber: bookmark.ayahNumber,
                      initialPageNumber: bookmark.pageNumber,
                    );
                  },
                ),
              ),
          },

        // Bottom padding to ensure floating navigation bar doesn't overlap last card
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }
}

/// Error view displaying a retry button if dataset fails to load.
class _QuranErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QuranErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.paleRadiance,
              size: 44.r,
            ),
            AppSpacing.verticalMd,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pureChalk,
                fontSize: 14.sp,
              ),
            ),
            AppSpacing.verticalMd,
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.champagneGold,
                foregroundColor: AppColors.obsidianCore,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
