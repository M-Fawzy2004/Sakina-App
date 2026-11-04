import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/services/quran_reader_preferences_storage.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_ambient_background.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_auto_scroll_timer.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_modal_controllers.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_page_calculator.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/reader/reader_scaffold_body.dart';

/// Full-screen illuminated Islamic manuscript sanctuary reader with audio recitation,
/// quick Surah navigation, offline tafsir, and hands-free auto-scrolling.
class QuranReaderView extends StatefulWidget {
  final SurahEntity surah;
  final List<AyahEntity> verses;
  final List<SurahEntity> allSurahs;
  final ValueChanged<SurahEntity>? onSurahChanged;
  final VoidCallback onClose;
  final ValueChanged<QuranBookmarkEntity> onBookmarkSaved;
  final int? recitingAyahNumber;
  final bool isAyahAudioPlaying;
  final bool isAyahAudioBuffering;
  final ValueChanged<int>? onPlayAyah;
  final VoidCallback? onStopAyah;
  final int? initialAyahNumber;
  final int? initialPageNumber;

  const QuranReaderView({
    super.key,
    required this.surah,
    required this.verses,
    this.allSurahs = const [],
    this.onSurahChanged,
    required this.onClose,
    required this.onBookmarkSaved,
    this.recitingAyahNumber,
    this.isAyahAudioPlaying = false,
    this.isAyahAudioBuffering = false,
    this.onPlayAyah,
    this.onStopAyah,
    this.initialAyahNumber,
    this.initialPageNumber,
  });

  @override
  State<QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<QuranReaderView> {
  late final PageController _pageController;
  final Map<int, ScrollController> _pageScrollControllers = {};
  final ReaderAutoScrollTimer _autoScrollTimer = ReaderAutoScrollTimer();
  QuranReaderPreferences _preferences = const QuranReaderPreferences();
  int _currentPageIndex = 0;
  int? _selectedAyahNumber;
  bool _hasThemeInitialized = false;
  bool _isTransitioningSurah = false;

  int get _versesPerPage =>
      ReaderPageCalculator.calculateVersesPerPage(widget.verses.length);

  int get _totalPages =>
      ReaderPageCalculator.calculateTotalPages(widget.verses.length);

  List<AyahEntity> _getVersesForPage(int pageIndex) {
    return ReaderPageCalculator.getVersesForPage(
      verses: widget.verses,
      pageIndex: pageIndex,
      versesPerPage: _versesPerPage,
    );
  }

  void _triggerSurahTransition(bool next) {
    if (_isTransitioningSurah) return;
    _isTransitioningSurah = true;
    if (next) {
      _handleNextPage();
    } else {
      _handlePreviousPage();
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _isTransitioningSurah = false;
    });
  }

  ScrollController _getScrollControllerForPage(int pageIndex) =>
      _pageScrollControllers.putIfAbsent(pageIndex, () => ScrollController());

  int _calculateInitialPageIndex([List<AyahEntity>? versesOverride]) =>
      ReaderPageCalculator.calculateInitialPageIndex(
        verses: versesOverride ?? widget.verses,
        totalPages: _totalPages,
        versesPerPage: _versesPerPage,
        initialAyahNumber: widget.initialAyahNumber,
        initialPageNumber: widget.initialPageNumber,
      );

  void _scrollToTargetAyahIfPresent() {
    final targetAyah = widget.initialAyahNumber;
    if (targetAyah == null || widget.verses.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final pageVerses = _getVersesForPage(_currentPageIndex);
      final indexInPage =
          pageVerses.indexWhere((v) => v.numberInSurah == targetAyah);
      if (indexInPage > 0) {
        final controller = _getScrollControllerForPage(_currentPageIndex);
        if (controller.hasClients) {
          final targetOffset = (indexInPage * 110.h).clamp(
            0.0,
            controller.position.maxScrollExtent,
          );
          controller.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (sl.isRegistered<PreferencesService>()) {
      _preferences = QuranReaderPreferencesStorage.load(sl<PreferencesService>());
    }
    _currentPageIndex = _calculateInitialPageIndex();
    _selectedAyahNumber = widget.initialAyahNumber;
    _pageController = PageController(initialPage: _currentPageIndex);
    _scrollToTargetAyahIfPresent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasThemeInitialized) {
      _hasThemeInitialized = true;
      final hasSaved = sl.isRegistered<PreferencesService>() &&
          sl<PreferencesService>().getString(QuranReaderPreferencesStorage.keyTheme) != null;
      if (!hasSaved) {
        _preferences = _preferences.copyWith(
          theme: ReaderPageCalculator.resolveDefaultTheme(
            isDark: context.isDark,
            isEmerald: context.colors.background == AppColors.emeraldSanctuaryCore,
            isObsidian: context.colors.background == AppColors.obsidianCore,
          ),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant QuranReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surah.id != widget.surah.id) {
      _currentPageIndex = _calculateInitialPageIndex();
      _selectedAyahNumber = widget.initialAyahNumber;
      for (final c in _pageScrollControllers.values) { c.dispose(); }
      _pageScrollControllers.clear();
      if (_pageController.hasClients) _pageController.jumpToPage(_currentPageIndex);
      _scrollToTargetAyahIfPresent();
    } else if (oldWidget.verses.isEmpty && widget.verses.isNotEmpty) {
      final target = _calculateInitialPageIndex();
      if (target != _currentPageIndex) {
        _currentPageIndex = target;
        if (_pageController.hasClients) _pageController.jumpToPage(target);
      }
      if (widget.initialAyahNumber != null) _selectedAyahNumber = widget.initialAyahNumber;
      _scrollToTargetAyahIfPresent();
    } else if (widget.recitingAyahNumber != null &&
        widget.recitingAyahNumber != oldWidget.recitingAyahNumber) {
      _autoPagingForRecitation(widget.recitingAyahNumber!);
    }
  }

  void _autoPagingForRecitation(int ayahNumber) {
    final target = (ayahNumber - 1) ~/ _versesPerPage;
    if (target != _currentPageIndex && target >= 0 && target < _totalPages) {
      _currentPageIndex = target;
      if (_pageController.hasClients) {
        _pageController.animateToPage(target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic);
      }
    }
  }

  @override
  void dispose() {
    _autoScrollTimer.dispose();
    _pageController.dispose();
    for (final c in _pageScrollControllers.values) {
      c.dispose();
    }
    _pageScrollControllers.clear();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer.start(
      speed: _preferences.autoScrollSpeed,
      getController: () => _getScrollControllerForPage(_currentPageIndex),
      canAdvancePage: () => _currentPageIndex < _totalPages - 1,
      onAdvancePage: () => _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onAyahTap(int ayahNumber) {
    HapticService.selectionClick();
    setState(() => _selectedAyahNumber =
        (_selectedAyahNumber == ayahNumber) ? null : ayahNumber);
    widget.onBookmarkSaved(QuranBookmarkEntity(
      surahId: widget.surah.id,
      surahName: widget.surah.nameArabic,
      ayahNumber: ayahNumber,
      pageNumber: widget.surah.pageNumber,
      timestamp: DateTime.now(),
    ));
  }

  void _handlePreviousPage() {
    if (_currentPageIndex > 0) {
      HapticService.selectionClick();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onSurahNav(isNext: false);
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
      _onSurahNav(isNext: true);
    }
  }

  void _onSurahNav({required bool isNext}) {
    if (widget.allSurahs.isEmpty || widget.onSurahChanged == null) return;
    final idx = widget.allSurahs.indexWhere((s) => s.id == widget.surah.id);
    final target = isNext ? idx + 1 : idx - 1;
    if (target >= 0 && target < widget.allSurahs.length) {
      widget.onSurahChanged!(widget.allSurahs[target]);
    }
  }

  void _handleSettingsChanged(QuranReaderPreferences p) {
    setState(() {
      _preferences = p;
      if (p.isAutoScrollEnabled) {
        _startAutoScroll();
      } else {
        _autoScrollTimer.stop();
      }
    });
    if (sl.isRegistered<PreferencesService>()) {
      unawaited(QuranReaderPreferencesStorage.save(sl<PreferencesService>(), p));
    }
  }

  void _handleSpeedChanged(double s) {
    HapticService.selectionClick();
    setState(() {
      _preferences = _preferences.copyWith(autoScrollSpeed: s);
      if (!_autoScrollTimer.isPaused) _startAutoScroll();
    });
    if (sl.isRegistered<PreferencesService>()) {
      unawaited(QuranReaderPreferencesStorage.save(sl<PreferencesService>(), _preferences));
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = _preferences.theme;
    final currentVerses = _getVersesForPage(_currentPageIndex);
    final activeAyah = widget.verses.firstWhere(
      (a) => a.numberInSurah == _selectedAyahNumber,
      orElse: () =>
          currentVerses.firstOrNull ??
          widget.verses.firstOrNull ??
          AyahEntity(
            numberInSurah: 1,
            text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            page: widget.surah.pageNumber,
            juz: widget.surah.juzNumber,
          ),
    );

    final start = _currentPageIndex * _versesPerPage + 1;
    final end = (start + currentVerses.length - 1).clamp(start, widget.verses.length);
    final pageLabel = _totalPages > 1
        ? 'الآيَاتُ $start - $end • ص ${_currentPageIndex + 1}/$_totalPages'
        : 'سُورَةُ ${widget.surah.nameArabic} • ص ${widget.surah.pageNumber} • جزء ${widget.surah.juzNumber}';

    return Scaffold(
      backgroundColor: activeTheme.backgroundColor,
      body: Stack(
        children: [
          ReaderAmbientBackground(theme: activeTheme),
          ReaderScaffoldBody(
            surah: widget.surah,
            verses: widget.verses,
            allSurahs: widget.allSurahs,
            preferences: _preferences,
            pageController: _pageController,
            totalPages: _totalPages,
            versesPerPage: _versesPerPage,
            selectedAyahNumber: _selectedAyahNumber,
            recitingAyahNumber: widget.recitingAyahNumber,
            isAyahAudioPlaying: widget.isAyahAudioPlaying,
            isAyahAudioBuffering: widget.isAyahAudioBuffering,
            isAutoScrollPaused: _autoScrollTimer.isPaused,
            pageLabel: pageLabel,
            activeAyahEntity: activeAyah,
            getScrollController: _getScrollControllerForPage,
            getVersesForPage: _getVersesForPage,
            onPageChanged: (i) => setState(() {
              _currentPageIndex = i;
              _selectedAyahNumber = null;
            }),
            onAyahTap: _onAyahTap,
            onPlayAyah: widget.onPlayAyah,
            onNextPage: _handleNextPage,
            onPreviousPage: _handlePreviousPage,
            onTriggerSurahTransition: _triggerSurahTransition,
            onBookmarkSaved: widget.onBookmarkSaved,
            onClose: widget.onClose,
            onOpenSurahSwitch: () => ReaderModalControllers.openSurahQuickSwitch(
              context: context,
              surah: widget.surah,
              allSurahs: widget.allSurahs,
              onSurahChanged: widget.onSurahChanged,
            ),
            onOpenSettings: () => ReaderModalControllers.openSettings(
              context: context,
              preferences: _preferences,
              onPreferencesChanged: _handleSettingsChanged,
            ),
            onToggleAutoScrollPause: () {
              HapticService.selectionClick();
              setState(() => _autoScrollTimer.togglePause());
            },
            onAutoScrollSpeedChanged: _handleSpeedChanged,
            onCloseAutoScroll: () {
              HapticService.selectionClick();
              _autoScrollTimer.stop();
              setState(() => _preferences =
                  _preferences.copyWith(isAutoScrollEnabled: false));
            },
            onTafsir: () => ReaderModalControllers.openTafsir(
              context: context,
              surah: widget.surah,
              ayah: activeAyah,
            ),
            onCopy: () => ReaderModalControllers.copyAyahOrPage(
              context: context,
              surah: widget.surah,
              selectedAyahNumber: _selectedAyahNumber,
              activeAyahEntity: activeAyah,
              currentVerses: currentVerses,
              currentPageIndex: _currentPageIndex,
              totalPages: _totalPages,
              activeTheme: activeTheme,
            ),
            onBookmark: () => ReaderModalControllers.toggleBookmark(
              context: context,
              surah: widget.surah,
              activeAyah: _selectedAyahNumber ?? 1,
              activeTheme: activeTheme,
              onBookmarkSaved: widget.onBookmarkSaved,
            ),
          ),
        ],
      ),
    );
  }
}
