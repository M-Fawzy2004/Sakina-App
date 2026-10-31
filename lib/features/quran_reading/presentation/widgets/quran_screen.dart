import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/juz_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/juz_tile.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_bookmarks_view.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_mushaf_brand_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_resume_reading_hero.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_search_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_shimmer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_mockup_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tab_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/surah_reader_screen.dart';

/// The Master Holy Quran Sanctuary Screen («القُرْآنُ الكَرِيمُ»).
/// Unified scrollable architecture delivering an organic, seamless experience:
/// 1. Symmetric Brand Header with Crescent & Calligraphy
/// 2. Resume Reading Hero Card with Silk Bookmark Ribbon
/// 3. Tab Navigation (Surahs 114, Juzs 30, Bookmarks)
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
      backgroundColor: AppColors.obsidianCore,
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

  void _navigateToSurah(SurahEntity surah) {
    SurahReaderScreen.open(context, surah);
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
                _navigateToSurah(targetSurah);
              },
            ),
          ),

        // 4. Tab Bar (Surahs 114, Juzs 30, Bookmarks)
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
          _SliverSurahsList(
            surahs: widget.state.filteredSurahs,
            onSurahTap: _navigateToSurah,
          )
        else
          switch (widget.state.selectedTab) {
            QuranTab.surahs => _SliverSurahsList(
              surahs: widget.state.filteredSurahs,
              onSurahTap: _navigateToSurah,
            ),
            QuranTab.juzs => _SliverJuzsList(
              juzs: widget.state.juzs,
              allSurahs: widget.state.allSurahs,
              onJuzTap: (juz) {
                final targetSurah = widget.state.allSurahs.firstWhere(
                  (s) => s.nameArabic == juz.startSurahName,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(targetSurah);
              },
            ),
            QuranTab.page => _SliverPagesList(
              allSurahs: widget.state.allSurahs,
              onPageTap: (pageNumber) {
                final targetSurah = widget.state.allSurahs.lastWhere(
                  (s) => s.pageNumber <= pageNumber,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(targetSurah);
              },
            ),
            QuranTab.hizbs => _SliverHizbsList(
              allSurahs: widget.state.allSurahs,
              onHizbTap: (hizbNumber) {
                final juzIndex = ((hizbNumber - 1) ~/ 2) + 1;
                final targetSurah = widget.state.allSurahs.firstWhere(
                  (s) => s.juzNumber >= juzIndex,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(targetSurah);
              },
            ),
            // ignore: unreachable_switch_case
            QuranTab.page => _SliverPagesList(
              allSurahs: widget.state.allSurahs,
              onPageTap: (pageNumber) {
                final targetSurah = widget.state.allSurahs.lastWhere(
                  (s) => s.pageNumber <= pageNumber,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(targetSurah);
              },
            ),
            // ignore: unreachable_switch_case
            QuranTab.hizbs => _SliverHizbsList(
              allSurahs: widget.state.allSurahs,
              onHizbTap: (hizbNumber) {
                final juzIndex = ((hizbNumber - 1) ~/ 2) + 1;
                final targetSurah = widget.state.allSurahs.firstWhere(
                  (s) => s.juzNumber >= juzIndex,
                  orElse: () => widget.state.allSurahs.first,
                );
                _navigateToSurah(targetSurah);
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
                  _navigateToSurah(targetSurah);
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

/// Slivers of Surah cards with circular number "(1)", recency, and reading status.
class _SliverSurahsList extends StatelessWidget {
  final List<SurahEntity> surahs;
  final ValueChanged<SurahEntity> onSurahTap;

  const _SliverSurahsList({required this.surahs, required this.onSurahTap});

  @override
  Widget build(BuildContext context) {
    if (surahs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Text(
              'لم يتم العثور على سور مطابقة للبحث',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedSilver,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final surah = surahs[index];
        return QuranSurahMockupCard(
          surah: surah,
          onTap: () => onSurahTap(surah),
        );
      }, childCount: surahs.length),
    );
  }
}

/// Slivers of 30 Juzs with smooth scroll.
class _SliverJuzsList extends StatelessWidget {
  final List<JuzEntity> juzs;
  final List<SurahEntity> allSurahs;
  final ValueChanged<JuzEntity> onJuzTap;

  const _SliverJuzsList({
    required this.juzs,
    required this.allSurahs,
    required this.onJuzTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final juz = juzs[index];
        return JuzTile(juz: juz, onTap: () => onJuzTap(juz));
      }, childCount: juzs.length),
    );
  }
}

/// Slivers of Quran pages (1 to 604) for jumping directly to any manuscript page.
class _SliverPagesList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<int> onPageTap;

  const _SliverPagesList({required this.allSurahs, required this.onPageTap});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final pageNum = index + 1;
        final surah = allSurahs.lastWhere(
          (s) => s.pageNumber <= pageNum,
          orElse: () => allSurahs.first,
        );

        return _PageTile(
          pageNumber: pageNum,
          surahName: surah.nameArabic,
          juzNumber: surah.juzNumber,
          onTap: () => onPageTap(pageNum),
        );
      }, childCount: 604),
    );
  }
}

class _PageTile extends StatelessWidget {
  final int pageNumber;
  final String surahName;
  final int juzNumber;
  final VoidCallback onTap;

  const _PageTile({
    required this.pageNumber,
    required this.surahName,
    required this.juzNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlowSoft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.goldBorderStroke.withValues(alpha: 0.25),
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.champagneGold,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$pageNumber',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الصَّفْحَةُ $pageNumber',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.pureChalk,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'سُورَةُ $surahName • الجُزْءُ $juzNumber',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.mutedSilver,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.champagneGold,
                  size: 14.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Slivers of 60 Hizbs.
class _SliverHizbsList extends StatelessWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<int> onHizbTap;

  const _SliverHizbsList({required this.allSurahs, required this.onHizbTap});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final hizbNum = index + 1;
        final juzIndex = ((hizbNum - 1) ~/ 2) + 1;
        final surah = allSurahs.firstWhere(
          (s) => s.juzNumber >= juzIndex,
          orElse: () => allSurahs.first,
        );

        return _HizbTile(
          hizbNumber: hizbNum,
          juzNumber: juzIndex,
          surahName: surah.nameArabic,
          onTap: () => onHizbTap(hizbNum),
        );
      }, childCount: 60),
    );
  }
}

class _HizbTile extends StatelessWidget {
  final int hizbNumber;
  final int juzNumber;
  final String surahName;
  final VoidCallback onTap;

  const _HizbTile({
    required this.hizbNumber,
    required this.juzNumber,
    required this.surahName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlowSoft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.goldBorderStroke.withValues(alpha: 0.25),
                width: 1.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.carbonSlate,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.emeraldGlow,
                      width: 1.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$hizbNumber',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.emeraldGlow,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الحِزْبُ $hizbNumber',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.pureChalk,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'الجُزْءُ $juzNumber • سُورَةُ $surahName',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.mutedSilver,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.champagneGold,
                  size: 14.r,
                ),
              ],
            ),
          ),
        ),
      ),
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
