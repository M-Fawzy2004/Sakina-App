import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_3d_page_turn.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_surah_header.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_floating_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tafsir_reflection_sheet.dart';

/// Full-screen 3D interactive manuscript reader:
/// - Top bar with `<` back navigation and central Surah title in gold
/// - Compact refined Surah header banner
/// - Authentic continuous justified Mushaf page with large, legible, straight typography
/// - Inline golden circular ayah markers
/// - Floating stadium action bar that operates on selected ayah or entire page seamlessly
class QuranReaderView extends StatefulWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final VoidCallback onClose;
  final ValueChanged<QuranBookmarkEntity> onBookmarkSaved;

  const QuranReaderView({
    super.key,
    required this.surah,
    required this.verses,
    required this.onClose,
    required this.onBookmarkSaved,
  });

  @override
  State<QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<QuranReaderView> {
  late final PageController _pageController;
  final Map<int, TapGestureRecognizer> _recognizers = {};
  double _currentPageValue = 0.0;
  int? _selectedAyahNumber;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPageValue = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    _recognizers.clear();
    _pageController.dispose();
    super.dispose();
  }

  TapGestureRecognizer _getRecognizer(int ayahNumber) {
    return _recognizers.putIfAbsent(ayahNumber, () {
      return TapGestureRecognizer()..onTap = () => _onAyahTap(ayahNumber);
    });
  }

  void _onAyahTap(int ayahNumber) {
    HapticService.selectionClick();
    setState(() {
      _selectedAyahNumber =
          (_selectedAyahNumber == ayahNumber) ? null : ayahNumber;
    });
  }

  void _toggleBookmark() {
    final activeAyah = _selectedAyahNumber ?? 1;

    widget.onBookmarkSaved(QuranBookmarkEntity(
      surahId: widget.surah.id,
      surahName: widget.surah.nameArabic,
      ayahNumber: activeAyah,
      pageNumber: widget.surah.pageNumber,
      timestamp: DateTime.now(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.carbonSlate,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.emeraldGlow, width: 1.r),
        ),
        content: Text(
          'تم تثبيت علامة الحفظ عند الآية $activeAyah من سورة ${widget.surah.nameArabic} ✓',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.emeraldGlow,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _copyContent(AyahEntity activeAyahEntity) {
    HapticService.selectionClick();

    if (_selectedAyahNumber != null) {
      Clipboard.setData(ClipboardData(
        text:
            '«${activeAyahEntity.text}» [سورة ${widget.surah.nameArabic}: ${activeAyahEntity.numberInSurah}]',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.carbonSlate,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.champagneGold, width: 1.r),
          ),
          content: Text(
            'تم نسخ الآية الكريمة بنجاح ✓',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.champagneGold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      final pageVersesText = widget.verses
          .map((a) => '${a.text} (${a.numberInSurah})')
          .join(' ');
      Clipboard.setData(ClipboardData(
        text:
            '«$pageVersesText» [سورة ${widget.surah.nameArabic} - الصفحة ${widget.surah.pageNumber}]',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.carbonSlate,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.champagneGold, width: 1.r),
          ),
          content: Text(
            'تم نسخ آيات الصفحة الحالية بنجاح ✓',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.champagneGold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  void _openTafsir(AyahEntity ayah) {
    QuranTafsirReflectionSheet.show(
      context: context,
      surah: widget.surah,
      ayah: ayah,
    );
  }

  void _onPreviousPage() {
    HapticService.selectionClick();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onNextPage() {
    HapticService.selectionClick();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAyahEntity = widget.verses.firstWhere(
      (a) => a.numberInSurah == _selectedAyahNumber,
      orElse: () => widget.verses.isNotEmpty
          ? widget.verses.first
          : AyahEntity(
              numberInSurah: 1,
              text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              page: widget.surah.pageNumber,
              juz: widget.surah.juzNumber,
            ),
    );

    return Scaffold(
      backgroundColor: AppColors.obsidianCore,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar matching Image 2 («<  سُورَةُ الكَهْفِ • مَكِّيَّة»)
            _ReaderTopBar(
              surah: widget.surah,
              onClose: widget.onClose,
            ),

            // 2. Compact Refined Surah Header Banner
            QuranOrnateSurahHeader(surah: widget.surah),

            // 3. 3D Manuscript Page View with continuous legible verses
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Quran3dPageTurn(
                    pageIndex: index,
                    currentPageValue: _currentPageValue,
                    child: _ManuscriptPageCard(
                      pageIndex: index,
                      surah: widget.surah,
                      verses: widget.verses,
                      selectedAyahNumber: _selectedAyahNumber,
                      onAyahTap: _onAyahTap,
                      recognizerBuilder: _getRecognizer,
                    ),
                  );
                },
              ),
            ),

            // 4. Floating Interactive Stadium Menu Bar (replaces old bottom bar)
            QuranReaderFloatingBar(
              pageNumber: widget.surah.pageNumber,
              juzNumber: widget.surah.juzNumber,
              selectedAyahNumber: _selectedAyahNumber,
              onPreviousPage: _onPreviousPage,
              onNextPage: _onNextPage,
              onPlay: () => _openTafsir(activeAyahEntity),
              onTafsir: () => _openTafsir(activeAyahEntity),
              onCopy: () => _copyContent(activeAyahEntity),
              onBookmark: _toggleBookmark,
            ),
          ],
        ),
      ),
    );
  }
}

/// The top bar of the reader view.
class _ReaderTopBar extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onClose;

  const _ReaderTopBar({
    required this.surah,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              HapticService.selectionClick();
              onClose();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.champagneGold,
              size: 20.r,
            ),
          ),
          Text(
            'سُورَةُ ${surah.nameArabic} • ${surah.revelationType}',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.champagneGold,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 44.r),
        ],
      ),
    );
  }
}

/// A clean manuscript page card with straight, legible Cairo typography.
class _ManuscriptPageCard extends StatelessWidget {
  final int pageIndex;
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final int? selectedAyahNumber;
  final ValueChanged<int> onAyahTap;
  final TapGestureRecognizer Function(int) recognizerBuilder;

  const _ManuscriptPageCard({
    required this.pageIndex,
    required this.surah,
    required this.verses,
    required this.selectedAyahNumber,
    required this.onAyahTap,
    required this.recognizerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final showBasmalah = pageIndex == 0 && surah.id != 9 && surah.id != 1;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 1.2.r,
        ),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
        children: [
          // 1. Classical Basmalah Banner on top of page 0
          if (showBasmalah) ...[
            Center(
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: AppTextStyles.quranAyah.copyWith(
                  fontSize: 22.sp,
                  color: AppColors.paleRadiance,
                  height: 2.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 14.h),
          ],

          // 2. Continuous Flowing Quranic Verses Paragraph with Crisp Cairo Font
          Text.rich(
            TextSpan(
              children: [
                for (final ayah in verses) ...[
                  TextSpan(
                    text: ayah.text,
                    recognizer: recognizerBuilder(ayah.numberInSurah),
                    style: AppTextStyles.quranAyah.copyWith(
                      fontSize: 22.sp,
                      height: 2.2,
                      color: selectedAyahNumber == ayah.numberInSurah
                          ? AppColors.champagneGold
                          : AppColors.pureChalk,
                      backgroundColor: selectedAyahNumber == ayah.numberInSurah
                          ? AppColors.emeraldGlow.withValues(alpha: 0.2)
                          : Colors.transparent,
                      fontWeight: selectedAyahNumber == ayah.numberInSurah
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () => onAyahTap(ayah.numberInSurah),
                      child: _AyahNumberBadge(
                        number: ayah.numberInSurah,
                        isHighlighted:
                            selectedAyahNumber == ayah.numberInSurah,
                      ),
                    ),
                  ),
                  const TextSpan(text: '  '),
                ],
              ],
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

/// Circular inline golden ayah number badge.
class _AyahNumberBadge extends StatelessWidget {
  final int number;
  final bool isHighlighted;

  const _AyahNumberBadge({
    required this.number,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.r,
      height: 25.r,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.carbonSlate,
        border: Border.all(
          color: isHighlighted
              ? AppColors.emeraldGlow
              : AppColors.champagneGold,
          width: 1.2.r,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: AppTextStyles.caption.copyWith(
            color: isHighlighted
                ? AppColors.emeraldGlow
                : AppColors.champagneGold,
            fontWeight: FontWeight.w800,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
