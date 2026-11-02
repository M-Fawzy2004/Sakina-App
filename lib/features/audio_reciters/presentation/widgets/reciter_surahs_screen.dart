import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/audio_recitation_player_screen.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_mini_player_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_profile_hero_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_surah_grid_card.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_surahs_shimmer_grid.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_surahs_top_bar.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/surah_inline_search_bar.dart';

/// Dark Luxury independent screen displaying all 114 Surahs for a curated Sheikh.
/// Rendered in a 2-column grid matching the Quran section aesthetic with zero drop-shadows.
class ReciterSurahsScreen extends StatefulWidget {
  final ReciterEntity reciter;

  const ReciterSurahsScreen({
    super.key,
    required this.reciter,
  });

  @override
  State<ReciterSurahsScreen> createState() => _ReciterSurahsScreenState();
}

class _ReciterSurahsScreenState extends State<ReciterSurahsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AudioRecitersCubit>().loadReciterTracks(widget.reciter);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AudioRecitersCubit, AudioRecitersState>(
          builder: (context, state) {
            final cubit = context.read<AudioRecitersCubit>();

            final filteredTracks = state.reciterTracks.where((track) {
              if (_filterQuery.trim().isEmpty) return true;
              final clean = _filterQuery.trim().toLowerCase();
              final arabicMatch =
                  track.surahNameArabic.toLowerCase().contains(clean);
              final idMatch = track.surahId.toString() == clean;
              return arabicMatch || idMatch;
            }).toList();

            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Top App Bar with back navigation
                    SliverToBoxAdapter(
                      child: ReciterSurahsTopBar(
                        reciterName: widget.reciter.nameArabic,
                        onBackTap: () {
                          HapticService.selectionClick();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                    // Reciter Profile Hero Card
                    SliverToBoxAdapter(
                      child: ReciterProfileHeroCard(
                        reciter: widget.reciter,
                        onPlayFirstTrack: () {
                          if (state.reciterTracks.isNotEmpty) {
                            cubit.playTrack(state.reciterTracks.first);
                          }
                        },
                        onShufflePlay: () {
                          if (state.reciterTracks.isNotEmpty) {
                            final randomIndex = math.Random()
                                .nextInt(state.reciterTracks.length);
                            cubit.playTrack(state.reciterTracks[randomIndex]);
                          }
                        },
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 14.h)),

                    // Surahs Search Bar
                    SliverToBoxAdapter(
                      child: SurahInlineSearchBar(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _filterQuery = val;
                          });
                        },
                        onClear: () {
                          _searchController.clear();
                          setState(() {
                            _filterQuery = '';
                          });
                        },
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                    // Section Heading
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'فهرس السور القرآنية',
                              style: GoogleFonts.cairo(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              '${filteredTracks.length} سورة',
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.accentGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Loading Shimmer or 2-Column Grid of Surahs
                    if (state.isLoadingTracks)
                      const SliverToBoxAdapter(
                        child: ReciterSurahsShimmerGrid(),
                      )
                    else if (filteredTracks.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 50.h,
                            horizontal: 24.w,
                          ),
                          child: Center(
                            child: Text(
                              'لم يتم العثور على سور تطابق بحثك',
                              style: GoogleFonts.cairo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      // 2-Column Grid of Surahs matching Quran Screen format
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            mainAxisExtent: 98.h,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final track = filteredTracks[index];
                              final isCurrentlyPlayingThis =
                                  state.isPlaying &&
                                      state.currentTrack?.reciterId ==
                                          track.reciterId &&
                                      state.currentTrack?.surahId ==
                                          track.surahId;

                              return ReciterSurahGridCard(
                                track: track,
                                isCurrentlyPlaying: isCurrentlyPlayingThis,
                                onTap: () {
                                  if (isCurrentlyPlayingThis) {
                                    cubit.togglePlayPause();
                                  } else {
                                    cubit.playTrack(track);
                                  }
                                },
                              );
                            },
                            childCount: filteredTracks.length,
                          ),
                        ),
                      ),

                    // Extra bottom space for floating mini player above safe area
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: bottomInset +
                            (state.currentTrack != null ? 96.h : 28.h),
                      ),
                    ),
                  ],
                ),

                // Floating Mini Player Bar at bottom when playing audio
                if (state.currentTrack != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomInset + 12.h,
                    child: ReciterMiniPlayerBar(
                      track: state.currentTrack!,
                      isPlaying: state.isPlaying,
                      onTap: () => _openPlayer(context),
                      onPlayPauseTap: cubit.togglePlayPause,
                      onDismiss: cubit.stopAndDismissTrack,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
