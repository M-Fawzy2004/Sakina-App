import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/usecases/get_last_read_bookmark_usecase.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/surah_reader_screen.dart';

/// Standard 114 Surah verse counts (Hafs recitation)
const List<int> _kSurahVerseCounts = [
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, // 1-10
  123, 111, 43, 52, 99, 128, 111, 110, 98, 135, // 11-20
  112, 78, 118, 64, 77, 227, 93, 88, 69, 60, // 21-30
  34, 30, 73, 54, 45, 83, 182, 88, 75, 85, // 31-40
  54, 53, 89, 59, 37, 35, 38, 29, 18, 45, // 41-50
  60, 49, 62, 55, 78, 96, 29, 22, 24, 13, // 51-60
  14, 11, 11, 18, 12, 12, 30, 52, 52, 44, // 61-70
  28, 28, 20, 56, 40, 31, 50, 40, 46, 42, // 71-80
  29, 19, 36, 25, 22, 17, 19, 26, 30, 20, // 81-90
  15, 21, 11, 8, 8, 19, 5, 8, 8, 11, // 91-100
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3, // 101-110
  5, 4, 5, 6 // 111-114
];

/// "واصل وردك القرآني" - Continue your Quranic portion card
/// Reflects the exact last read position saved locally from the Quran reader:
/// - Real-time Surah name, Ayah number, and Page position
/// - Accurate percentage calculation relative to the Surah
/// - Tactile "مواصلة القراءة" action button
/// - Zero drop shadows and completely local offline persistence.
class MaladhContinueQuranCard extends StatefulWidget {
  final VoidCallback? onResumeTap;
  final VoidCallback? onCardTap;
  final QuranBookmarkEntity? initialBookmark;

  const MaladhContinueQuranCard({
    super.key,
    this.onResumeTap,
    this.onCardTap,
    this.initialBookmark,
  });

  @override
  State<MaladhContinueQuranCard> createState() =>
      _MaladhContinueQuranCardState();
}

class _MaladhContinueQuranCardState extends State<MaladhContinueQuranCard> {
  QuranBookmarkEntity? _bookmark;

  @override
  void initState() {
    super.initState();
    _bookmark = widget.initialBookmark;
    if (_bookmark == null) {
      _loadBookmark();
    }
  }

  Future<void> _loadBookmark() async {
    try {
      final useCase = sl<GetLastReadBookmarkUseCase>();
      final result = await useCase(const NoParams());
      result.fold(
        (failure) {},
        (bookmark) {
          if (mounted && bookmark != null) {
            setState(() {
              _bookmark = bookmark;
            });
          }
        },
      );
    } catch (_) {
      // Graceful fallback
    }
  }

  void _openReaderDirectly() {
    final b = _bookmark;
    final surahId = b?.surahId ?? 2;
    final totalVerses = (surahId >= 1 && surahId <= 114)
        ? _kSurahVerseCounts[surahId - 1]
        : 286;
    final surah = SurahEntity(
      id: surahId,
      nameArabic: b?.surahName ?? 'سُورَةُ البَقَرَةِ',
      englishName: '',
      revelationType: '',
      versesCount: totalVerses,
      pageNumber: b?.pageNumber ?? 2,
      juzNumber: 1,
    );
    SurahReaderScreen.open(
      context,
      surah,
      initialAyahNumber: b?.ayahNumber ?? 1,
      initialPageNumber: b?.pageNumber ?? 2,
    );
  }

  void _handleTap() {
    HapticService.selectionClick();
    if (widget.onResumeTap != null) {
      widget.onResumeTap!();
    } else if (widget.onCardTap != null) {
      widget.onCardTap!();
    } else {
      _openReaderDirectly();
    }
  }

  @override
  Widget build(BuildContext context) {
    final surahId = _bookmark?.surahId ?? 2;
    final surahName = _bookmark?.surahName ?? 'سُورَةُ البَقَرَةِ';
    final totalVerses = (surahId >= 1 && surahId <= 114)
        ? _kSurahVerseCounts[surahId - 1]
        : 286;
    final currentAyah = (_bookmark?.ayahNumber ?? 1).clamp(1, totalVerses);
    final pageNumber = _bookmark?.pageNumber ?? 2;
    final progress = (currentAyah / totalVerses).clamp(0.01, 1.0);
    final percent = (progress * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        onTap: _handleTap,
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ContinueHeaderRow(percent: percent),
            SizedBox(height: 10.h),
            _ContinueSurahInfo(
              surahName: surahName,
              currentAyah: currentAyah,
              totalVerses: totalVerses,
              pageNumber: pageNumber,
            ),
            AppSpacing.verticalMd,
            _ContinueProgressBar(progress: progress),
            SizedBox(height: 12.h),
            const _ContinueActionRow(),
          ],
        ),
      ),
    );
  }
}

/// Header row featuring the Quranic tag and percentage badge.
class _ContinueHeaderRow extends StatelessWidget {
  final int percent;

  const _ContinueHeaderRow({
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tag
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: colors.accentGold,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'وَاصِلْ وِرْدَكَ القُرْآنِيّ',
                style: GoogleFonts.cairo(
                  color: colors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ),
        ),

        // Percentage Pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.bookmark5,
                size: 13.r,
                color: colors.accentGold,
              ),
              SizedBox(width: 4.w),
              Text(
                '$percent%',
                style: GoogleFonts.cairo(
                  color: colors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Surah Title & Metadata info section.
class _ContinueSurahInfo extends StatelessWidget {
  final String surahName;
  final int currentAyah;
  final int totalVerses;
  final int pageNumber;

  const _ContinueSurahInfo({
    required this.surahName,
    required this.currentAyah,
    required this.totalVerses,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          surahName,
          textAlign: TextAlign.start,
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: 25.sp,
            color: colors.accentGold,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'الآية $currentAyah من $totalVerses • صفحة $pageNumber',
          textAlign: TextAlign.start,
          style: GoogleFonts.cairo(
            color: colors.textSecondary,
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Linear reading progress bar.
class _ContinueProgressBar extends StatelessWidget {
  final double progress;

  const _ContinueProgressBar({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 4.5.h,
        backgroundColor: colors.surfaceElevated,
        valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
      ),
    );
  }
}

/// Bottom action row with indication text and tactile CTA pill.
class _ContinueActionRow extends StatelessWidget {
  const _ContinueActionRow();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'آخِرُ مَوْضِعٍ تَمَّتْ قِرَاءَتُهُ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              color: colors.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colors.accentGold,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مُوَاصَلَةُ القِرَاءَةِ',
                style: GoogleFonts.cairo(
                  color: colors.isDark
                      ? AppColors.obsidianCore
                      : AppColors.inkDeep,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Iconsax.arrow_left_2,
                size: 13.r,
                color: colors.isDark
                    ? AppColors.obsidianCore
                    : AppColors.inkDeep,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
