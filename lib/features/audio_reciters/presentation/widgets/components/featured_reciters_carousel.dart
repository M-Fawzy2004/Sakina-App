import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';
import 'package:sakina_app/features/audio_reciters/presentation/widgets/components/reciter_avatar_medallion.dart';

/// Interactive Luxury Sheikhs Carousel with smooth horizontal swipe and live dynamic indicator dots.
class FeaturedRecitersCarousel extends StatefulWidget {
  final List<ReciterEntity> featuredReciters;
  final int activeIndex;
  final bool isPlaying;
  final int? currentlyPlayingReciterId;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<ReciterEntity> onPlayTap;
  final ValueChanged<ReciterEntity> onCardTap;

  const FeaturedRecitersCarousel({
    super.key,
    required this.featuredReciters,
    required this.activeIndex,
    required this.isPlaying,
    this.currentlyPlayingReciterId,
    required this.onPageChanged,
    required this.onPlayTap,
    required this.onCardTap,
  });

  @override
  State<FeaturedRecitersCarousel> createState() => _FeaturedRecitersCarouselState();
}

class _FeaturedRecitersCarouselState extends State<FeaturedRecitersCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.activeIndex,
      viewportFraction: 0.93,
    );
  }

  @override
  void didUpdateWidget(covariant FeaturedRecitersCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != oldWidget.activeIndex &&
        _pageController.hasClients &&
        _pageController.page?.round() != widget.activeIndex) {
      _pageController.animateToPage(
        widget.activeIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredReciters.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.featuredReciters.length,
            onPageChanged: widget.onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final reciter = widget.featuredReciters[index];
              final isCurrentPlaying = widget.isPlaying &&
                  widget.currentlyPlayingReciterId == reciter.id;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: _FeaturedSheikhCard(
                  reciter: reciter,
                  isPlaying: isCurrentPlaying,
                  onPlayTap: () => widget.onPlayTap(reciter),
                  onCardTap: () => widget.onCardTap(reciter),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),

        // Interactive dynamic page indicator dots
        _LiveCarouselIndicatorDots(
          totalDots: widget.featuredReciters.length,
          activeIndex: widget.activeIndex,
          onDotTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}

class _FeaturedSheikhCard extends StatelessWidget {
  final ReciterEntity reciter;
  final bool isPlaying;
  final VoidCallback onPlayTap;
  final VoidCallback onCardTap;

  const _FeaturedSheikhCard({
    required this.reciter,
    required this.isPlaying,
    required this.onPlayTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.carbonSlate,
          borderRadius: AppSpacing.radiusLg,
          border: Border.all(
            color: isPlaying ? AppColors.champagneGold : AppColors.goldBorderStroke,
            width: isPlaying ? 1.5.r : 1.r,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surfaceElevated,
              AppColors.carbonSlate,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Badge: «شيخ اليوم» or «جوهرة التلاوات» with Rosette dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 5.r,
                  height: 5.r,
                  decoration: const BoxDecoration(
                    color: AppColors.champagneGold,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'شيخ اليوم • تلاوة مختارة',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.champagneGold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 5.r,
                  height: 5.r,
                  decoration: const BoxDecoration(
                    color: AppColors.champagneGold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            // Center: Medallion Avatar with Ornate Ring
            ReciterAvatarMedallion(
              photoUrl: reciter.photoUrl,
              nameArabic: reciter.nameArabic,
              size: 72,
              isGlowing: isPlaying,
            ),

            // Bottom Row: Sheikh name, Riwayah and Circular Play Button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              reciter.nameArabic,
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.pureChalk,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPlaying) ...[
                            SizedBox(width: 6.w),
                            const _MiniEqualizerPulsar(),
                          ],
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        reciter.revelationStyle,
                        style: GoogleFonts.amiri(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.paleRadiance,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),

                // Concentric Golden Play Action Button
                GestureDetector(
                  onTap: onPlayTap,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlaying ? AppColors.champagneGold : AppColors.frostedGlass,
                      border: Border.all(
                        color: AppColors.champagneGold,
                        width: 1.5.r,
                      ),
                    ),
                    child: Icon(
                      isPlaying ? Iconsax.pause : Iconsax.play,
                      color: isPlaying ? AppColors.obsidianCore : AppColors.champagneGold,
                      size: 20.r,
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

/// Mini live pulsing audio waves inside the card when active
class _MiniEqualizerPulsar extends StatelessWidget {
  const _MiniEqualizerPulsar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: AppColors.emeraldGlow,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 3.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.champagneGold,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 3.w,
          height: 9.h,
          decoration: BoxDecoration(
            color: AppColors.paleRadiance,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}

/// Dynamic live page indicator dots that expand and collapse as user swipes
class _LiveCarouselIndicatorDots extends StatelessWidget {
  final int totalDots;
  final int activeIndex;
  final ValueChanged<int> onDotTap;

  const _LiveCarouselIndicatorDots({
    required this.totalDots,
    required this.activeIndex,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeIndex;
        return GestureDetector(
          onTap: () => onDotTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: isActive ? 22.w : 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.champagneGold
                  : AppColors.mutedSilver.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        );
      }),
    );
  }
}
