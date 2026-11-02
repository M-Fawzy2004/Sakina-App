import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_chapter_entity.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_cubit.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/cubit/hisn_state.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_category_chips.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_chapter_card.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_dua_card.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_header.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/components/hisn_search_field.dart';
import 'package:sakina_app/features/hisn_muslim/presentation/widgets/hisn_chapter_detail_screen.dart';

class HisnMuslimScreen extends StatelessWidget {
  const HisnMuslimScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const HisnMuslimScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HisnCubit>.value(
      value: sl<HisnCubit>()..ensureLoaded(),
      child: const _HisnMuslimContent(),
    );
  }
}

class _HisnMuslimContent extends StatefulWidget {
  const _HisnMuslimContent();

  @override
  State<_HisnMuslimContent> createState() => _HisnMuslimContentState();
}

class _HisnMuslimContentState extends State<_HisnMuslimContent> {
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
    final cubit = context.read<HisnCubit>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<HisnCubit, HisnState>(
          builder: (context, state) {
            if (state is HisnError) {
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
                      onPressed: () => cubit.loadHisn(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is HisnLoaded) {
              final isSearching = state.isSearching;
              final showDirectDuas = isSearching && state.searchResults.isNotEmpty;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: HisnHeader(
                      onBackTap: () => Navigator.of(context).pop(),
                      totalChapters: state.allChapters.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: HisnSearchField(
                      controller: _searchController,
                      onChanged: (val) => cubit.search(val),
                      onClear: () => cubit.clearSearch(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                  if (!isSearching)
                    SliverToBoxAdapter(
                      child: HisnCategoryChips(
                        categories: state.categories,
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: (cat) => cubit.filterByCategory(cat),
                      ),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                  if (showDirectDuas) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        child: Text(
                          'نتائج البحث في نصوص الأدعية (${state.searchResults.length}):',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.accentGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final dua = state.searchResults[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: HisnDuaCard(
                                dua: dua,
                                index: index + 1,
                                totalInChapter: state.searchResults.length,
                              ),
                            );
                          },
                          childCount: state.searchResults.length,
                        ),
                      ),
                    ),
                  ] else ...[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final chapter = state.filteredChapters[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: HisnChapterCard(
                                chapter: chapter,
                                onTap: () => _openChapter(context, chapter),
                              ),
                            );
                          },
                          childCount: state.filteredChapters.length,
                        ),
                      ),
                    ),
                  ],

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

  void _openChapter(BuildContext context, HisnChapterEntity chapter) {
    HisnChapterDetailScreen.open(context, chapter);
  }
}
