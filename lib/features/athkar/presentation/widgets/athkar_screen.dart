import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_cubit.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_state.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_category_selector.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_header.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_item_card.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_progress_card.dart';

/// The Master Athkar Sanctuary Screen («الأَذْكَارُ وَالمَسَابِحُ»).
/// 100% offline-first presentation of authentic prophetic Athkar & Duas:
/// - Categorized selection (Morning, Evening, Tasbeeh, Sleep, Prayer, etc.)
/// - Interactive tactile repetition counter with dynamic progress
/// - Clean luxury OLED dark design with zero drop-shadows
class AthkarScreen extends StatelessWidget {
  final String? initialCategory;

  const AthkarScreen({
    super.key,
    this.initialCategory,
  });

  /// Opens the Athkar sanctuary screen via root navigator.
  static Future<void> open(
    BuildContext context, {
    String? initialCategory,
  }) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AthkarScreen(initialCategory: initialCategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AthkarCubit>.value(
      value: sl<AthkarCubit>()..ensureLoaded(initialCategory: initialCategory),
      child: const _AthkarScreenContent(),
    );
  }
}

class _AthkarScreenContent extends StatelessWidget {
  const _AthkarScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<AthkarCubit>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocBuilder<AthkarCubit, AthkarState>(
          builder: (context, state) {
            if (state is AthkarError) {
              return _AthkarErrorView(
                message: state.message,
                onRetry: () => cubit.loadAthkar(),
              );
            }

            if (state is AthkarLoaded) {
              final activeCategoryMeta = state.categories.firstWhere(
                (c) => c.name == state.selectedCategory,
                orElse: () => AthkarCategoryEntity(
                  name: state.selectedCategory,
                  count: state.activeAthkar.length,
                  description: 'أوراد نبوية مباركة',
                  iconKey: 'tasbih',
                ),
              );

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // 1. Top Sanctuary Header
                  SliverToBoxAdapter(
                    child: AthkarHeader(
                      onBackTap: () => Navigator.of(context).pop(),
                      onResetCategoryTap: () => cubit.resetCategory(),
                    ),
                  ),

                  SliverToBoxAdapter(child: AppSpacing.verticalXs),

                  // 2. Horizontal Category Selector Strip
                  SliverToBoxAdapter(
                    child: AthkarCategorySelector(
                      categories: state.categories,
                      selectedCategory: state.selectedCategory,
                      onSelectCategory: (cat) => cubit.selectCategory(cat),
                    ),
                  ),

                  SliverToBoxAdapter(child: AppSpacing.verticalSm),

                  // 3. Category Progress Summary Card
                  SliverToBoxAdapter(
                    child: AthkarProgressCard(
                      categoryName: state.selectedCategory,
                      description: activeCategoryMeta.description,
                      totalCount: state.activeAthkar.length,
                      completedCount: state.totalCompletedCount,
                      progress: state.completionProgress,
                    ),
                  ),

                  SliverToBoxAdapter(child: AppSpacing.verticalSm),

                  // 4. Athkar Items List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.activeAthkar[index];
                        final current = state.progressMap[index] ?? 0;
                        return AthkarItemCard(
                          item: item,
                          itemIndex: index,
                          currentRepetitions: current,
                          onTapCount: () => cubit.tapThikr(index),
                          onReset: () => cubit.resetThikr(index),
                        );
                      },
                      childCount: state.activeAthkar.length,
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32.h)),
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

class _AthkarErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AthkarErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: colors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'إِعَادَةُ المُحَاوَلَةِ',
                style: GoogleFonts.cairo(
                  color: colors.isDark
                      ? AppColors.obsidianCore
                      : AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
