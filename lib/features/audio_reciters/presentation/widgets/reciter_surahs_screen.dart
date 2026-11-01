import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_cubit.dart';
import 'package:sakina_app/features/audio_reciters/presentation/cubit/audio_reciters_state.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/audio_recitation_player_screen.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_mini_player_bar.dart';
import 'package:sakina_app/features/quran_reading/data/datasources/quran_local_data_source.dart';

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
              final arabicMatch = track.surahNameArabic.toLowerCase().contains(clean);
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
                      child: _ReciterSurahsTopBar(
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
                      child: _ReciterProfileHeroCard(
                        reciter: widget.reciter,
                        onPlayFirstTrack: () {
                          if (state.reciterTracks.isNotEmpty) {
                            cubit.playTrack(state.reciterTracks.first);
                          }
                        },
                        onShufflePlay: () {
                          if (state.reciterTracks.isNotEmpty) {
                            final randomIndex = math.Random().nextInt(state.reciterTracks.length);
                            cubit.playTrack(state.reciterTracks[randomIndex]);
                          }
                        },
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 14.h)),

                    // Surahs Search Bar
                    SliverToBoxAdapter(
                      child: _SurahInlineSearchBar(
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
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.h),
                          child: Center(
                            child: SizedBox(
                              width: 32.r,
                              height: 32.r,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (filteredTracks.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 24.w),
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
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            mainAxisExtent: 98.h,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final track = filteredTracks[index];
                              final isCurrentlyPlayingThis = state.isPlaying &&
                                  state.currentTrack?.reciterId == track.reciterId &&
                                  state.currentTrack?.surahId == track.surahId;

                              return _ReciterSurahGridCard(
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
                        height: bottomInset + (state.currentTrack != null ? 96.h : 28.h),
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

class _ReciterSurahsTopBar extends StatelessWidget {
  final String reciterName;
  final VoidCallback onBackTap;

  const _ReciterSurahsTopBar({
    required this.reciterName,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cardSurface,
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.6),
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.arrow_right_3,
                size: 18.r,
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'المصحف المرتل',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.accentGold,
                  ),
                ),
                Text(
                  reciterName,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.5),
                width: 0.8.r,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.headphone,
                  size: 13.r,
                  color: colors.accentGold,
                ),
                SizedBox(width: 4.w),
                Text(
                  'استماع مباشر',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReciterProfileHeroCard extends StatelessWidget {
  final ReciterEntity reciter;
  final VoidCallback onPlayFirstTrack;
  final VoidCallback onShufflePlay;

  const _ReciterProfileHeroCard({
    required this.reciter,
    required this.onPlayFirstTrack,
    required this.onShufflePlay,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: AppSpacing.radiusLg,
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Ornate Avatar Medallion with Avatar Letter
                ReciterAvatarMedallion(
                  photoUrl: reciter.photoUrl,
                  nameArabic: reciter.nameArabic,
                  avatarLetter: reciter.avatarLetter,
                  size: 64,
                  isGlowing: true,
                ),
                SizedBox(width: 14.w),

                // Reciter Sacred Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reciter.nameArabic,
                        style: GoogleFonts.cairo(
                          fontSize: 16.5.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        reciter.revelationStyle,
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.accentGold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: colors.borderHairline.withValues(alpha: 0.5),
                                width: 0.8.r,
                              ),
                            ),
                            child: Text(
                              reciter.riwayah,
                              style: GoogleFonts.cairo(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: colors.borderHairline.withValues(alpha: 0.5),
                                width: 0.8.r,
                              ),
                            ),
                            child: Text(
                              '114 سورة كاملة',
                              style: GoogleFonts.cairo(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Action Buttons (Play from beginning / Shuffle)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onPlayFirstTrack();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      decoration: BoxDecoration(
                        color: colors.accentGold,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.play5,
                            size: 16.r,
                            color: colors.background,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'بدء من الفاتحة',
                              style: GoogleFonts.cairo(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.background,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onShufflePlay();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: colors.borderHairline.withValues(alpha: 0.7),
                          width: 1.r,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.shuffle,
                            size: 16.r,
                            color: colors.textPrimary,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'تشغيل عشوائي',
                              style: GoogleFonts.cairo(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahInlineSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SurahInlineSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.6),
            width: 1.r,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal_1,
              size: 16.r,
              color: colors.accentGold,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن اسم السورة أو رقمها...',
                  hintStyle: GoogleFonts.cairo(
                    fontSize: 12.5.sp,
                    color: colors.textSecondary.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(14.r),
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Iconsax.close_circle,
                    size: 16.r,
                    color: colors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 2-Column Responsive Card for Surahs matching the user's Quran section mockup:
/// - Left: Details Column (Calligraphic Surah Title, Revelation type & Verse count, Page number)
/// - Right: Rounded Square Capsule with Surah ID number on top + Play/Pause icon underneath
/// - Direct audio listening with tactile feedback and zero drop-shadows
class _ReciterSurahGridCard extends StatelessWidget {
  final RecitationTrackEntity track;
  final bool isCurrentlyPlaying;
  final VoidCallback onTap;

  const _ReciterSurahGridCard({
    required this.track,
    required this.isCurrentlyPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surahMetadata = (track.surahId >= 1 && track.surahId <= 114)
        ? QuranLocalDataSourceImpl.allSurahs[track.surahId - 1]
        : null;

    final revelationType = surahMetadata?.revelationType ?? 'مكية';
    final versesCount = surahMetadata?.versesCount ?? 0;
    final pageNumber = surahMetadata?.pageNumber ?? 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isCurrentlyPlaying ? colors.surfaceElevated : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isCurrentlyPlaying
                  ? colors.accentGold
                  : colors.borderHairline.withValues(alpha: 0.65),
              width: isCurrentlyPlaying ? 1.5.r : 1.r,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                // 1. Left: Details Column (Calligraphic Title, Revelation Type & Verse Count, Page Number)
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Surah Calligraphic Title (Amiri)
                        Text(
                          track.surahNameArabic,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.amiri(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: isCurrentlyPlaying ? colors.accentGold : colors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Revelation Type & Verses Count
                        Text(
                          '$revelationType، آياتها : $versesCount',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Page Number
                        Text(
                          'الصفحة $pageNumber',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary.withValues(alpha: 0.8),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // 2. Right: Surah ID number capsule + Audio Play/Pause indicator
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: isCurrentlyPlaying
                            ? colors.accentGold.withValues(alpha: 0.2)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isCurrentlyPlaying
                              ? colors.accentGold
                              : colors.borderHairline.withValues(alpha: 0.6),
                          width: 1.r,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${track.surahId}',
                        style: GoogleFonts.cairo(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: isCurrentlyPlaying ? colors.accentGold : colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      isCurrentlyPlaying ? Iconsax.pause5 : Iconsax.play5,
                      size: 13.r,
                      color: isCurrentlyPlaying
                          ? colors.accentGold
                          : colors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
