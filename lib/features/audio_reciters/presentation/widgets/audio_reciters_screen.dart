import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/audio_recitation_player_screen.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/featured_reciters_carousel.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_mini_player_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_tile_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_filter_chips.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_header_app_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_search_bar.dart';

/// Recitations Discovery Screen with pure natural OLED dark canvas.
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

  /// Opens the player on the root navigator so it sits completely above the navigation shell.
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
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    // SakinaBottomNavBar floats at bottomPadding + 12.h with height 68.h (top edge at bottomPadding + 80.h)
    final miniPlayerBottom = bottomPadding + 84.h;
    final scrollBottomPadding = stateTrackPadding(context, bottomPadding);

    return Scaffold(
      backgroundColor: AppColors.obsidianCore,
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
                  slivers: [
                    // Top Sacred Header: "سكينة 🌙" and "واجهة التلاوات"
                    const SliverToBoxAdapter(
                      child: RecitersHeaderAppBar(),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: 8.h),
                    ),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: RecitersSearchBar(
                        onChanged: cubit.search,
                        onClear: () => cubit.search(''),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: 12.h),
                    ),

                    // Horizontal Filter Chips
                    SliverToBoxAdapter(
                      child: RecitersFilterChips(
                        categories: state.categories,
                        selectedCategory: state.selectedCategory,
                        onSelected: cubit.selectCategory,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: 14.h),
                    ),

                    // Interactive Sheikhs Carousel (if search is empty)
                    if (state.searchQuery.isEmpty && state.featuredReciters.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: FeaturedRecitersCarousel(
                          featuredReciters: state.featuredReciters,
                          activeIndex: state.activeFeaturedIndex,
                          isPlaying: state.isPlaying,
                          currentlyPlayingReciterId: state.currentTrack?.reciterId,
                          onPageChanged: cubit.setFeaturedIndex,
                          onPlayTap: (reciter) async {
                            await cubit.playReciterFeaturedTrack(reciter);
                            if (context.mounted) {
                              _openPlayer(context);
                            }
                          },
                          onCardTap: (reciter) async {
                            await cubit.playReciterFeaturedTrack(reciter);
                            if (context.mounted) {
                              _openPlayer(context);
                            }
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 14.h),
                      ),
                    ],

                    // Reciters List Header
                    const SliverToBoxAdapter(
                      child: _CatalogSectionHeader(),
                    ),

                    // Loading Indicator
                    if (state.isLoading)
                      const SliverToBoxAdapter(
                        child: _RecitersLoadingShimmer(),
                      )
                    else if (state.reciters.isEmpty)
                      const SliverToBoxAdapter(
                        child: _EmptyRecitersNotice(),
                      )
                    else
                      // Reciter Tiles List
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reciter = state.reciters[index];
                            final isCurrentPlaying = state.isPlaying &&
                                state.currentTrack?.reciterId == reciter.id;

                            return ReciterTileCard(
                              reciter: reciter,
                              isCurrentPlaying: isCurrentPlaying,
                              onTap: () async {
                                await cubit.playReciterFeaturedTrack(reciter);
                                if (context.mounted) {
                                _openPlayer(context);
                              }
                            },
                            onActionTap: () async {
                              if (isCurrentPlaying) {
                                await cubit.togglePlayPause();
                              } else {
                                await cubit.playReciterFeaturedTrack(reciter);
                              }
                            },
                          );
                        },
                        childCount: state.reciters.length,
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
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: miniPlayerBottom,
                    child: ReciterMiniPlayerBar(
                      track: state.currentTrack!,
                      isPlaying: state.isPlaying,
                      onTap: () => _openPlayer(context),
                      onPlayPauseTap: cubit.togglePlayPause,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  double stateTrackPadding(BuildContext context, double bottomPadding) {
    final state = context.watch<AudioRecitersCubit>().state;
    // Bottom nav bar takes ~80.h + bottomPadding. Mini player takes ~60.h.
    return bottomPadding + (state.currentTrack != null ? 154.h : 96.h);
  }
}

class _CatalogSectionHeader extends StatelessWidget {
  const _CatalogSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'قراء القرآن الكريم',
            style: GoogleFonts.cairo(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.pureChalk,
            ),
          ),
          Text(
            'عرض الكل',
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.champagneGold,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Center(
        child: SizedBox(
          width: 32.r,
          height: 32.r,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
          ),
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
