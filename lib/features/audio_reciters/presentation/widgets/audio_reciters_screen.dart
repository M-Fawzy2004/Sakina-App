import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/audio_recitation_player_screen.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/live_stream_channels_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_grid_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_mini_player_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_filter_chips.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_header_app_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_search_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/reciter_surahs_screen.dart';

/// Dark Luxury Recitations Discovery Screen:
/// Features:
/// 1. Live Holy Sanctuaries Broadcast (البث المباشر: الحرم المكي والمسجد النبوي).
/// 2. 2-Column Responsive Grid of Curated Sheikhs Cards (No longer a single vertical list).
/// 3. Zero drop-shadows across all surfaces for pure spiritual elegance.
class AudioRecitersScreen extends StatelessWidget {
  const AudioRecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AudioRecitersCubit>()..loadCatalog(),
      child: const _AudioRecitersView(),
    );
  }
}

class _AudioRecitersView extends StatelessWidget {
  const _AudioRecitersView();

  void _openPlayer(BuildContext context) {
    final cubit = context.read<AudioRecitersCubit>();
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlocProvider.value(
            value: cubit,
            child: const AudioRecitationPlayerScreen(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _openReciterSurahs(BuildContext context, ReciterEntity reciter) {
    final cubit = context.read<AudioRecitersCubit>();
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlocProvider.value(
            value: cubit,
            child: ReciterSurahsScreen(reciter: reciter),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardInset > 0;
    final miniPlayerBottom = bottomPadding + 84.h;
    final scrollBottomPadding = isKeyboardOpen
        ? keyboardInset + 20.h
        : stateTrackPadding(context, bottomPadding);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: context.colors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<AudioRecitersCubit, AudioRecitersState>(
            listener: (context, state) {
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage!,
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pureChalk,
                      ),
                    ),
                    backgroundColor: AppColors.carbonSlate,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<AudioRecitersCubit>();

              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      // Top Sacred Header: "سكينة 🌙" and "واجهة التلاوات"
                      const SliverToBoxAdapter(child: RecitersHeaderAppBar()),

                      SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                      // Search Bar
                      SliverToBoxAdapter(
                        child: RecitersSearchBar(
                          onChanged: cubit.search,
                          onClear: () => cubit.search(''),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                      // Horizontal Filter Chips
                      SliverToBoxAdapter(
                        child: RecitersFilterChips(
                          categories: state.categories,
                          selectedCategory: state.selectedCategory,
                          onSelected: cubit.selectCategory,
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 14.h)),

                      // 1. Live Sanctuary Broadcast Section (البث المباشر للحرمين الشريفين)
                      SliverToBoxAdapter(
                        child: LiveStreamChannelsSection(
                          currentTrack: state.currentTrack,
                          isPlaying: state.isPlaying,
                          onChannelTap: (liveTrack) {
                            if (state.isPlaying &&
                                state.currentTrack?.audioUrl == liveTrack.audioUrl) {
                              cubit.togglePlayPause();
                            } else {
                              cubit.playTrack(liveTrack);
                            }
                          },
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                      // 2. Curated Top Sheikhs Section Header
                      SliverToBoxAdapter(
                        child: _CuratedSectionHeader(count: state.reciters.length),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 6.h)),

                      // 3. 2-Column Responsive Grid of Curated Sheikhs Cards (No longer a single vertical list)
                      if (state.isLoading)
                        const SliverToBoxAdapter(
                          child: _RecitersLoadingShimmer(),
                        )
                      else if (state.errorMessage != null && state.reciters.isEmpty)
                        SliverToBoxAdapter(
                          child: _RecitersErrorCard(
                            message: state.errorMessage!,
                            onRetry: () => cubit.loadCatalog(),
                          ),
                        )
                      else if (state.reciters.isEmpty)
                        const SliverToBoxAdapter(child: _EmptyRecitersNotice())
                      else
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.h,
                              crossAxisSpacing: 10.w,
                              mainAxisExtent: 168.h,
                            ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final reciter = state.reciters[index];
                              final isCurrentPlaying = state.isPlaying &&
                                  state.currentTrack?.reciterId == reciter.id;

                              return ReciterGridCard(
                                reciter: reciter,
                                isCurrentPlaying: isCurrentPlaying,
                                onTap: () => _openReciterSurahs(context, reciter),
                              );
                            }, childCount: state.reciters.length),
                          ),
                        ),

                      // Bottom spacing ensuring content scrolls completely above the floating nav bar and mini player
                      SliverToBoxAdapter(
                        child: SizedBox(height: scrollBottomPadding),
                      ),
                    ],
                  ),

                  // Floating Mini Player Bar - Positioned comfortably ABOVE bottom navigation bar
                  if (state.currentTrack != null)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      left: 0,
                      right: 0,
                      bottom: isKeyboardOpen ? -100.h : miniPlayerBottom,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isKeyboardOpen ? 0.0 : 1.0,
                        curve: Curves.easeOutCubic,
                        child: IgnorePointer(
                          ignoring: isKeyboardOpen,
                          child: ReciterMiniPlayerBar(
                            track: state.currentTrack!,
                            isPlaying: state.isPlaying,
                            onTap: () => _openPlayer(context),
                            onPlayPauseTap: cubit.togglePlayPause,
                            onDismiss: cubit.stopAndDismissTrack,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double stateTrackPadding(BuildContext context, double bottomPadding) {
    final state = context.watch<AudioRecitersCubit>().state;
    return bottomPadding + (state.currentTrack != null ? 154.h : 96.h);
  }
}

class _CuratedSectionHeader extends StatelessWidget {
  final int count;

  const _CuratedSectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'أشهر القراء',
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.borderHairline.withValues(alpha: 0.6),
                    width: 0.8.r,
                  ),
                ),
                child: Text(
                  '$count شيوخ',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'تسجيلات نقية كاملة',
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecitersLoadingShimmer extends StatelessWidget {
  const _RecitersLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Shimmer.fromColors(
        baseColor: colors.surfaceElevated,
        highlightColor: colors.cardSurface,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            mainAxisExtent: 168.h,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 80.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 50.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 70.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecitersErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RecitersErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.wifi_square,
                size: 26.r,
                color: colors.accentGold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'تَعَذَّرَ الِاتِّصَالُ بِمَكْتَبَةِ التِّلَاوَاتِ',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              message.isNotEmpty
                  ? message
                  : 'تأكد من اتصالك بالإنترنت لتصفح وتحميل التلاوات العذبة من خوادم البث المباشر.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                HapticService.selectionClick();
                onRetry();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.accentGold,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.refresh,
                      size: 15.r,
                      color: colors.isDark ? AppColors.obsidianCore : AppColors.white,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'إِعَادَةُ المُحَاوَلَةِ',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.isDark ? AppColors.obsidianCore : AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRecitersNotice extends StatelessWidget {
  const _EmptyRecitersNotice();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Center(
        child: Text(
          'لم يتم العثور على قراء يطابقون بحثك',
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedSilver,
          ),
        ),
      ),
    );
  }
}
