import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_cubit.dart';
import 'package:sakina_app/features/maladh/presentation/cubit/maladh_state.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_continue_quran_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_daily_goal_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_featured_recitation_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_header.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_header_shimmer.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_portals_section.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_prayer_tracker_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_reflection_card.dart';

/// Al-Maladh (The Sanctuary) screen serving as the primary spiritual dashboard of Sakina.
/// Built with pure, crisp OLED dark canvas without blurry drop shadows,
/// live prayer countdown ticker, daily prayer schedule & tracker,
/// "إِنْجَازُ الوِرْدِ اليَوْمِي" progress tracker, "واصل وردك القرآني" card,
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
    return Scaffold(
      backgroundColor: AppColors.obsidianCore,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 680.w),
            child: RefreshIndicator(
              color: AppColors.champagneGold,
              backgroundColor: AppColors.carbonSlate,
              onRefresh: () => context.read<MaladhCubit>().refreshSanctuaryData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.only(top: 6.h, bottom: 120.h),
                child: BlocBuilder<MaladhCubit, MaladhState>(
                  builder: (context, state) {
                    return switch (state) {
                      MaladhInitial() || MaladhLoading() => const MaladhHeaderShimmer(),
                      MaladhLoaded(:final headerData) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Master Sanctuary Header (Brand + Greeting + Live Countdown)
                            MaladhHeader(
                              data: headerData,
                              onNotificationTap: () {
                                // Notification center
                              },
                            ),

                            AppSpacing.verticalSm,

                            // 2. All-Prayers Daily Schedule & Tracking Card (English times & checkmarks)
                            MaladhPrayerTrackerCard(
                              onPrayerToggled: (prayerId) {
                                // Toggle prayer completion state
                              },
                            ),

                            AppSpacing.verticalSm,

                            // 3. "إِنْجَازُ الوِرْدِ اليَوْمِي" - Daily Quranic Goal Progress Card
                            const MaladhDailyGoalCard(),

                            AppSpacing.verticalSm,

                            // 4. "واصل وردك القرآني" - Continue Quranic Portion Card
                            MaladhContinueQuranCard(
                              onResumeTap: () {
                                // Resume recitation
                              },
                            ),

                            AppSpacing.verticalMd,

                            // 5. "بَوَّابَاتُ السَّكِينَةِ" - 2x2 Quick Access Spiritual Portals
                            MaladhPortalsSection(
                              onDirectAccessTap: () {
                                // View all portals
                              },
                              onMushafTap: () {
                                // Navigate to Mushaf reader
                              },
                              onMaqraTap: () {
                                // Navigate to reciter library
                              },
                              onCardMakerTap: () {
                                // Open verse card generator
                              },
                              onAthkarTap: () {
                                // Open Athkar & digital tasbih
                              },
                            ),

                            AppSpacing.verticalSm,

                            // 6. "تلاوة اللحظة المختارة" - Animated Featured Recitation Player Card
                            MaladhFeaturedRecitationCard(
                              onPlayPauseTap: () {
                                // Play/pause audio playback toggle
                              },
                            ),

                            AppSpacing.verticalSm,

                            // 7. "آيَةُ السَّكِينَةِ وَالتَّدَبُّرِ" - Daily Reflection Card
                            MaladhReflectionCard(
                              verseText: headerData.dailyVerseText,
                              surahSource: headerData.dailyVerseSurah,
                              onBookmarkTap: () {
                                // Bookmark saved verse
                              },
                            ),
                          ],
                        ),
                      MaladhError(:final message) => _MaladhErrorView(
                          message: message,
                          onRetry: () => context.read<MaladhCubit>().loadSanctuaryData(),
                        ),
                    };
                  },
                ),
              ),
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
