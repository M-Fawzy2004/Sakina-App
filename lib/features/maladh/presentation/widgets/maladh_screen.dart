import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/router/route_constants.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_cubit.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_state.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_celestial_sliver_header.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_continue_quran_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_featured_recitation_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_header_shimmer.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_portals_section.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_schedule_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_reflection_card.dart';

/// Al-Maladh (The Sanctuary) screen serving as the primary spiritual dashboard of Sakina.
/// Built with an atmospheric celestial Sliver header that gracefully collapses on scroll,
/// prominent inspiring Quranic verse, "واصل وردك القرآني" card,
/// "بَوَّابَاتُ السَّكِينَةِ" 2x2 portals grid, "تلاوة اللحظة المختارة" animated audio player,
/// and "آيَةُ السَّكِينَةِ وَالتَّدَبُّرِ" daily reflection card.
class MaladhScreen extends StatelessWidget {
  const MaladhScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaladhCubit>(
      create: (context) => sl<MaladhCubit>()..loadSanctuaryData(),
      child: const _MaladhView(),
    );
  }
}

class _MaladhView extends StatelessWidget {
  const _MaladhView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colors.background,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 680.w),
          child: RefreshIndicator(
            color: AppColors.champagneGold,
            backgroundColor: AppColors.carbonSlate,
            onRefresh: () => context.read<MaladhCubit>().refreshSanctuaryData(),
            child: BlocBuilder<MaladhCubit, MaladhState>(
              builder: (context, state) {
                return switch (state) {
                  MaladhInitial() || MaladhLoading() => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: topPadding + 8.h),
                            child: const MaladhHeaderShimmer(),
                          ),
                        ),
                      ],
                    ),
                  MaladhLoaded(:final headerData) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // 1. Large Collapsible Celestial Sliver Header with Inspiring Ayah
                        MaladhCelestialSliverHeader(
                          data: headerData,
                          onPlayVerseTap: () {
                            // Audio recitation action
                          },
                        ),

                        // 2. Sanctuary Dashboard Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.h,
                              bottom: 120.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // A. Prayer Times Schedule & Live Countdown Card
                                MaladhPrayerScheduleCard(
                                  hijriDate: headerData.hijriDate,
                                  nextPrayerName: headerData.nextPrayerName,
                                ),

                                AppSpacing.verticalSm,

                                // B. "واصل وردك القرآني" - Continue Quranic Portion Card
                                const MaladhContinueQuranCard(),

                                AppSpacing.verticalMd,

                                // B. "بَوَّابَاتُ السَّكِينَةِ" - 2x2 Quick Access Spiritual Portals
                                MaladhPortalsSection(
                                  onDirectAccessTap: () {
                                    context.go(AppRoutes.quran);
                                  },
                                  onMushafTap: () {
                                    context.go(AppRoutes.quran);
                                  },
                                  onMaqraTap: () {
                                    context.go(AppRoutes.audio);
                                  },
                                  onCardMakerTap: () {
                                    // Verse card maker preserved for later
                                  },
                                  onAthkarTap: () {
                                    context.push(AppRoutes.athkar);
                                  },
                                ),

                                AppSpacing.verticalSm,

                                // C. "تلاوة اللحظة المختارة" - Animated Featured Recitation Player Card
                                MaladhFeaturedRecitationCard(
                                  onPlayPauseTap: () {
                                    // Play/pause audio playback toggle
                                  },
                                ),

                                AppSpacing.verticalSm,

                                // D. "آيَةُ السَّكِينَةِ وَالتَّدَبُّرِ" - Daily Reflection Card
                                MaladhReflectionCard(
                                  verseText: headerData.dailyVerseText,
                                  surahSource: headerData.dailyVerseSurah,
                                  onBookmarkTap: () {
                                    // Bookmark saved verse
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  MaladhError(:final message) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: topPadding + 40.h),
                            child: _MaladhErrorView(
                              message: message,
                              onRetry: () =>
                                  context.read<MaladhCubit>().loadSanctuaryData(),
                            ),
                          ),
                        ),
                      ],
                    ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MaladhErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MaladhErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
            textAlign: TextAlign.center,
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
            child: Text('إِعَادَةُ الْمُحَاوَلَةِ', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
