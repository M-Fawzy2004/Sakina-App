import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
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
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciters_status_views.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/reciter_surahs_screen.dart';

/// Dark Luxury Recitations Discovery Screen:
/// Features:
/// 1. Live Holy Sanctuaries Broadcast (البث المباشر للحرمين الشريفين).
/// 2. 2-Column Responsive Grid of Curated Sheikhs Cards.
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
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty) {
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      const SliverToBoxAdapter(child: RecitersHeaderAppBar()),
                      SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                      SliverToBoxAdapter(
                        child: RecitersSearchBar(
                          onChanged: cubit.search,
                          onClear: () => cubit.search(''),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                      SliverToBoxAdapter(
                        child: RecitersFilterChips(
                          categories: state.categories,
                          selectedCategory: state.selectedCategory,
                          onSelected: cubit.selectCategory,
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 14.h)),
                      SliverToBoxAdapter(
                        child: LiveStreamChannelsSection(
                          currentTrack: state.currentTrack,
                          isPlaying: state.isPlaying,
                          onChannelTap: (liveTrack) {
                            if (state.isPlaying &&
                                state.currentTrack?.audioUrl ==
                                    liveTrack.audioUrl) {
                              cubit.togglePlayPause();
                            } else {
                              cubit.playTrack(liveTrack);
                            }
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(
                        child:
                            CuratedSectionHeader(count: state.reciters.length),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 6.h)),
                      if (state.isLoading)
                        const SliverToBoxAdapter(
                          child: RecitersLoadingShimmer(),
                        )
                      else if (state.errorMessage != null &&
                          state.reciters.isEmpty)
                        SliverToBoxAdapter(
                          child: RecitersErrorCard(
                            message: state.errorMessage!,
                            onRetry: () => cubit.loadCatalog(),
                          ),
                        )
                      else if (state.reciters.isEmpty)
                        const SliverToBoxAdapter(child: EmptyRecitersNotice())
                      else
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                onTap: () =>
                                    _openReciterSurahs(context, reciter),
                              );
                            }, childCount: state.reciters.length),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: scrollBottomPadding),
                      ),
                    ],
                  ),
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
