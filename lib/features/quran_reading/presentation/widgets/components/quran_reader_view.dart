import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/constants/app_assets.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_ornate_manuscript_card.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_floating_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_settings_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_top_bar.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_quick_switch_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tafsir_reflection_sheet.dart';

/// Full-screen illuminated Islamic manuscript sanctuary reader:
/// - Spiritual night mosque wallpaper (`AppAssets.quranBackground`) with atmospheric tint
/// - Circular frosted glass navigation buttons powered 100% by Iconsax
/// - Central stadium capsule Surah dropdown (`سُورَةُ الفَاتِحَةِ  ⌄`) for instant surah switching
/// - Ornate golden manuscript frame supporting both Verse-by-Verse & Continuous Mushaf flow
/// - Discrete 4-step font size adjustments with live rendering
/// - Floating stadium action bar with page navigation, Tafsir, Copy, and Bookmark capabilities
/// - Smooth hands-free Auto-Scroll Recitation with speed adjustments
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
  static const int kVersesPerPage = 10;

  late final PageController _pageController;
  final Map<int, ScrollController> _pageScrollControllers = {};
  QuranReaderPreferences _preferences = const QuranReaderPreferences();
  int _currentPageIndex = 0;
  int? _selectedAyahNumber;
  Timer? _autoScrollTimer;
  bool _isAutoScrollPaused = false;
  bool _hasThemeInitialized = false;

  int get _totalPages => widget.verses.isEmpty
      ? 1
      : ((widget.verses.length - 1) ~/ kVersesPerPage) + 1;

  List<AyahEntity> _getVersesForPage(int pageIndex) {
    final start = pageIndex * kVersesPerPage;
    if (start >= widget.verses.length) return const [];
    final end = (start + kVersesPerPage).clamp(0, widget.verses.length);
    return widget.verses.sublist(start, end);
  }

  ScrollController _getScrollControllerForPage(int pageIndex) {
    return _pageScrollControllers.putIfAbsent(
      pageIndex,
      () => ScrollController(),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasThemeInitialized) {
      _hasThemeInitialized = true;
      if (!context.isDark && _preferences.theme == QuranReaderTheme.obsidian) {
        _preferences = _preferences.copyWith(theme: QuranReaderTheme.parchment);
      }
    }
  }

  @override
  void didUpdateWidget(covariant QuranReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surah.id != widget.surah.id) {
      _currentPageIndex = 0;
      _selectedAyahNumber = null;
      for (final controller in _pageScrollControllers.values) {
        controller.dispose();
      }
      _pageScrollControllers.clear();
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    for (final controller in _pageScrollControllers.values) {
      controller.dispose();
    }
    _pageScrollControllers.clear();
    super.dispose();
  }

  void _startAutoScroll() {
    _stopAutoScroll();
    _isAutoScrollPaused = false;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isAutoScrollPaused) return;
      final controller = _getScrollControllerForPage(_currentPageIndex);
      if (!controller.hasClients) return;

      final maxScroll = controller.position.maxScrollExtent;
      final currentScroll = controller.position.pixels;
      if (currentScroll >= maxScroll) {
        if (_currentPageIndex < _totalPages - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          _stopAutoScroll();
        }
        return;
      }
      final step = 0.8 * _preferences.autoScrollSpeed;
      controller.jumpTo(currentScroll + step);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _toggleAutoScrollPause() {
    HapticService.selectionClick();
    setState(() {
      _isAutoScrollPaused = !_isAutoScrollPaused;
    });
  }

  void _onAyahTap(int ayahNumber) {
    HapticService.selectionClick();
    setState(() {
      _selectedAyahNumber = (_selectedAyahNumber == ayahNumber)
          ? null
          : ayahNumber;
    });
  }

  void _handlePreviousPage() {
    if (_currentPageIndex > 0) {
      HapticService.selectionClick();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onPreviousSurah();
    }
  }

  void _handleNextPage() {
    if (_currentPageIndex < _totalPages - 1) {
      HapticService.selectionClick();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onNextSurah();
    }
  }

  void _toggleBookmark() {
    final activeAyah = _selectedAyahNumber ?? 1;
    final activeTheme = _preferences.theme;

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
        backgroundColor: activeTheme.cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: activeTheme.accentColor,
            width: 1.r,
          ),
        ),
        content: Row(
          children: [
            Icon(
              Iconsax.bookmark,
              color: activeTheme.accentColor,
              size: 18.r,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'تم تثبيت علامة الحفظ عند الآية $activeAyah من سورة ${widget.surah.nameArabic} ✓',
                style: AppTextStyles.caption.copyWith(
                  color: activeTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyContent(AyahEntity activeAyahEntity) {
    HapticService.selectionClick();
    final activeTheme = _preferences.theme;

    if (_selectedAyahNumber != null) {
      Clipboard.setData(
        ClipboardData(
          text:
              '«${activeAyahEntity.text}» [سورة ${widget.surah.nameArabic}: ${activeAyahEntity.numberInSurah}]',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: activeTheme.cardColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: activeTheme.accentColor,
              width: 1.r,
            ),
          ),
          content: Row(
            children: [
              Icon(
                Iconsax.tick_circle,
                color: activeTheme.accentColor,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'تم نسخ الآية الكريمة بنجاح ✓',
                style: AppTextStyles.caption.copyWith(
                  color: activeTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final currentVerses = _getVersesForPage(_currentPageIndex);
      final versesToCopy =
          currentVerses.isNotEmpty ? currentVerses : widget.verses;
      final pageVersesText = versesToCopy
          .map((a) => '${a.text} (${a.numberInSurah})')
          .join(' ');
      Clipboard.setData(
        ClipboardData(
          text:
              '«$pageVersesText» [سورة ${widget.surah.nameArabic} - ص ${_currentPageIndex + 1}/$_totalPages]',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: activeTheme.cardColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: activeTheme.accentColor,
              width: 1.r,
            ),
          ),
          content: Row(
            children: [
              Icon(
                Iconsax.tick_circle,
                color: activeTheme.accentColor,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'تم نسخ آيات الصفحة بنجاح ✓',
                style: AppTextStyles.caption.copyWith(
                  color: activeTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
      useRootNavigator: true,
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
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          return QuranReaderSettingsSheet(
            preferences: _preferences,
            onPreferencesChanged: (newPrefs) {
              setModalState(() {
                _preferences = newPrefs;
              });
              setState(() {
                _preferences = newPrefs;
                if (newPrefs.isAutoScrollEnabled) {
                  _startAutoScroll();
                } else {
                  _stopAutoScroll();
                }
              });
            },
          );
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
    final activeTheme = _preferences.theme;
    final currentPageVerses = _getVersesForPage(_currentPageIndex);
    final activeAyahEntity = widget.verses.firstWhere(
      (a) => a.numberInSurah == _selectedAyahNumber,
      orElse: () => currentPageVerses.isNotEmpty
          ? currentPageVerses.first
          : (widget.verses.isNotEmpty
              ? widget.verses.first
              : AyahEntity(
                  numberInSurah: 1,
                  text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  page: widget.surah.pageNumber,
                  juz: widget.surah.juzNumber,
                )),
    );

    final startVerse = _currentPageIndex * kVersesPerPage + 1;
    final endVerse = (startVerse + currentPageVerses.length - 1).clamp(
      startVerse,
      widget.verses.length,
    );
    final pageLabel = _totalPages > 1
        ? 'الآيَاتُ $startVerse - $endVerse • ص ${_currentPageIndex + 1}/$_totalPages'
        : 'ص ${widget.surah.pageNumber} • جزء ${widget.surah.juzNumber}';

    return Scaffold(
      backgroundColor: activeTheme.backgroundColor,
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

          // 2. Translucent Ambient Theme Gradient Veil
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    activeTheme.backgroundColor.withValues(alpha: 0.40),
                    activeTheme.backgroundColor.withValues(alpha: 0.78),
                    activeTheme.backgroundColor.withValues(alpha: 0.96),
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
                // Top Bar: Back `<` Button, Dropdown Capsule, Settings `⚙`
                QuranReaderTopBar(
                  surah: widget.surah,
                  onClose: widget.onClose,
                  onOpenSurahSwitch: _openSurahQuickSwitch,
                  onOpenSettings: _openSettings,
                  accentColor: activeTheme.accentColor,
                  cardColor: activeTheme.cardColor,
                ),

                // Center Ornate Illuminated Manuscript Card with Horizontal 10-Verse Paging
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _totalPages,
                    onPageChanged: (newIndex) {
                      HapticService.selectionClick();
                      setState(() {
                        _currentPageIndex = newIndex;
                        _selectedAyahNumber = null;
                      });
                    },
                    itemBuilder: (context, pageIndex) {
                      final pageVerses = _getVersesForPage(pageIndex);
                      final isFirstPage = pageIndex == 0;
                      final startVerseNum = pageIndex * kVersesPerPage + 1;
                      final endVerseNum =
                          (startVerseNum + pageVerses.length - 1).clamp(
                        startVerseNum,
                        widget.verses.length,
                      );

                      return QuranOrnateManuscriptCard(
                        surah: widget.surah,
                        verses: pageVerses,
                        preferences: _preferences,
                        selectedAyahNumber: _selectedAyahNumber,
                        onAyahTap: _onAyahTap,
                        scrollController:
                            _getScrollControllerForPage(pageIndex),
                        pageIndex: pageIndex,
                        totalPages: _totalPages,
                        showBasmalahOnThisPage: isFirstPage,
                        verseRangeLabel:
                            'الآيَاتُ $startVerseNum - $endVerseNum',
                      );
                    },
                  ),
                ),

                // Hands-Free Auto Scroll Floating Capsule (when enabled)
                if (_preferences.isAutoScrollEnabled)
                  _AutoScrollControlBar(
                    isPaused: _isAutoScrollPaused,
                    accentColor: activeTheme.accentColor,
                    cardColor: activeTheme.cardColor,
                    textColor: activeTheme.textColor,
                    speed: _preferences.autoScrollSpeed,
                    onTogglePause: _toggleAutoScrollPause,
                    onSpeedChanged: (speed) {
                      HapticService.selectionClick();
                      setState(() {
                        _preferences =
                            _preferences.copyWith(autoScrollSpeed: speed);
                        if (!_isAutoScrollPaused) {
                          _startAutoScroll();
                        }
                      });
                    },
                    onClose: () {
                      HapticService.selectionClick();
                      _stopAutoScroll();
                      setState(() {
                        _preferences =
                            _preferences.copyWith(isAutoScrollEnabled: false);
                      });
                    },
                  ),

                // Floating Interactive Stadium Menu Bar
                QuranReaderFloatingBar(
                  pageNumber: widget.surah.pageNumber,
                  juzNumber: widget.surah.juzNumber,
                  pageLabel: pageLabel,
                  selectedAyahNumber: _selectedAyahNumber,
                  onPreviousPage: _handlePreviousPage,
                  onNextPage: _handleNextPage,
                  onPlay: () => _openTafsir(activeAyahEntity),
                  onTafsir: () => _openTafsir(activeAyahEntity),
                  onCopy: () => _copyContent(activeAyahEntity),
                  onBookmark: _toggleBookmark,
                  accentColor: activeTheme.accentColor,
                  cardColor: activeTheme.cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating tactical pill for managing hands-free auto-scrolling speed & pause state.
class _AutoScrollControlBar extends StatelessWidget {
  final bool isPaused;
  final Color accentColor;
  final Color? cardColor;
  final Color? textColor;
  final double speed;
  final VoidCallback onTogglePause;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onClose;

  const _AutoScrollControlBar({
    required this.isPaused,
    required this.accentColor,
    this.cardColor,
    this.textColor,
    required this.speed,
    required this.onTogglePause,
    required this.onSpeedChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (cardColor ?? AppColors.carbonSlate).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.6),
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onTogglePause,
            icon: Icon(
              isPaused ? Iconsax.play : Iconsax.pause,
              color: accentColor,
              size: 18.r,
            ),
          ),
          Text(
            isPaused ? 'مُتَوَقِّفٌ' : 'تَمْرِيرٌ تِلْقَائِيٌّ',
            style: AppTextStyles.caption.copyWith(
              color: textColor ?? AppColors.pureChalk,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(width: 8.w),
          _SpeedPill(
            label: '1x',
            isActive: speed == 1.0,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(1.0),
          ),
          SizedBox(width: 4.w),
          _SpeedPill(
            label: '1.5x',
            isActive: speed == 1.5,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(1.5),
          ),
          SizedBox(width: 4.w),
          _SpeedPill(
            label: '2x',
            isActive: speed == 2.0,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(2.0),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Iconsax.close_circle,
              color: AppColors.mutedSilver,
              size: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _SpeedPill({
    required this.label,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: isActive
              ? accentColor.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isActive
              ? Border.all(color: accentColor, width: 0.8.r)
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? accentColor : AppColors.mutedSilver,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
