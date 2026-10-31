import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/constants/app_assets.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_manuscript_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_floating_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_settings_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_top_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_quick_switch_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tafsir_reflection_sheet.dart';

/// Full-screen illuminated Islamic manuscript sanctuary reader:
/// - Spiritual night mosque wallpaper (`AppAssets.quranBackground`) with crescent moon illumination
/// - Circular frosted glass navigation `<` and settings `⚙` buttons
/// - Central stadium capsule Surah dropdown (`سُورَةُ الفَاتِحَةِ  ⌄`) for instant surah switching
/// - Ornate golden manuscript frame with Islamic crests, Basmalah banner, and floral ornaments
/// - Illuminated line-by-line verses with authentic golden eight-pointed Islamic star badges
/// - Floating stadium action bar with page navigation, Tafsir, Copy, and Bookmark capabilities.
class QuranReaderView extends StatefulWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final List<SurahEntity> allSurahs;
  final ValueChanged<SurahEntity>? onSurahChanged;
  final VoidCallback onClose;
  final ValueChanged<QuranBookmarkEntity> onBookmarkSaved;

  const QuranReaderView({
    super.key,
    required this.surah,
    required this.verses,
    this.allSurahs = const [],
    this.onSurahChanged,
    required this.onClose,
    required this.onBookmarkSaved,
  });

  @override
  State<QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<QuranReaderView> {
  int? _selectedAyahNumber;
  double _fontSizeDelta = 0.0;

  void _onAyahTap(int ayahNumber) {
    HapticService.selectionClick();
    setState(() {
      _selectedAyahNumber = (_selectedAyahNumber == ayahNumber)
          ? null
          : ayahNumber;
    });
  }

  void _toggleBookmark() {
    final activeAyah = _selectedAyahNumber ?? 1;

    widget.onBookmarkSaved(
      QuranBookmarkEntity(
        surahId: widget.surah.id,
        surahName: widget.surah.nameArabic,
        ayahNumber: activeAyah,
        pageNumber: widget.surah.pageNumber,
        timestamp: DateTime.now(),
      ),
    );

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
      Clipboard.setData(
        ClipboardData(
          text:
              '«${activeAyahEntity.text}» [سورة ${widget.surah.nameArabic}: ${activeAyahEntity.numberInSurah}]',
        ),
      );
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
      Clipboard.setData(
        ClipboardData(
          text:
              '«$pageVersesText» [سورة ${widget.surah.nameArabic} - الصفحة ${widget.surah.pageNumber}]',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.carbonSlate,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.champagneGold, width: 1.r),
          ),
          content: Text(
            'تم نسخ آيات السورة الكريمة بنجاح ✓',
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

  void _openSurahQuickSwitch() {
    if (widget.allSurahs.isEmpty || widget.onSurahChanged == null) return;
    HapticService.selectionClick();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => QuranSurahQuickSwitchSheet(
        currentSurahId: widget.surah.id,
        allSurahs: widget.allSurahs,
        onSurahSelected: (selectedSurah) {
          Navigator.of(bottomSheetContext).pop();
          widget.onSurahChanged?.call(selectedSurah);
        },
      ),
    );
  }

  void _openSettings() {
    HapticService.selectionClick();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => QuranReaderSettingsSheet(
        fontSizeDelta: _fontSizeDelta,
        onFontSizeChanged: (newDelta) {
          setState(() {
            _fontSizeDelta = newDelta;
          });
        },
      ),
    );
  }

  void _onPreviousSurah() {
    if (widget.allSurahs.isEmpty || widget.onSurahChanged == null) return;
    final currentIndex = widget.allSurahs.indexWhere(
      (s) => s.id == widget.surah.id,
    );
    if (currentIndex > 0) {
      widget.onSurahChanged!(widget.allSurahs[currentIndex - 1]);
    }
  }

  void _onNextSurah() {
    if (widget.allSurahs.isEmpty || widget.onSurahChanged == null) return;
    final currentIndex = widget.allSurahs.indexWhere(
      (s) => s.id == widget.surah.id,
    );
    if (currentIndex >= 0 && currentIndex < widget.allSurahs.length - 1) {
      widget.onSurahChanged!(widget.allSurahs[currentIndex + 1]);
    }
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
      body: Stack(
        children: [
          // 1. Spiritual Holy Mosque Wallpaper
          Positioned.fill(
            child: Image.asset(
              AppAssets.quranBackground,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // 2. Translucent Obsidian Core Gradient Veil for Optimal Contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.obsidianCore.withValues(alpha: 0.35),
                    AppColors.obsidianCore.withValues(alpha: 0.72),
                    AppColors.obsidianCore.withValues(alpha: 0.94),
                  ],
                  stops: const [0.0, 0.35, 0.85],
                ),
              ),
            ),
          ),

          // 3. Illuminated Reader Foreground
          SafeArea(
            child: Column(
              children: [
                // Top Bar: Circular Back `<` Button, Dropdown Capsule, Settings `⚙`
                QuranReaderTopBar(
                  surah: widget.surah,
                  onClose: widget.onClose,
                  onOpenSurahSwitch: _openSurahQuickSwitch,
                  onOpenSettings: _openSettings,
                ),

                // Center Ornate Illuminated Manuscript Card with Verses
                Expanded(
                  child: QuranOrnateManuscriptCard(
                    surah: widget.surah,
                    verses: widget.verses,
                    fontSizeDelta: _fontSizeDelta,
                    selectedAyahNumber: _selectedAyahNumber,
                    onAyahTap: _onAyahTap,
                  ),
                ),

                // Floating Interactive Stadium Menu Bar
                QuranReaderFloatingBar(
                  pageNumber: widget.surah.pageNumber,
                  juzNumber: widget.surah.juzNumber,
                  selectedAyahNumber: _selectedAyahNumber,
                  onPreviousPage: _onPreviousSurah,
                  onNextPage: _onNextSurah,
                  onPlay: () => _openTafsir(activeAyahEntity),
                  onTafsir: () => _openTafsir(activeAyahEntity),
                  onCopy: () => _copyContent(activeAyahEntity),
                  onBookmark: _toggleBookmark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
