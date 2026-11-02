import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_reader_settings_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_surah_quick_switch_sheet.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tafsir_reflection_sheet.dart';

/// Modal dialogs, bottom sheets, and clipboard helpers for Quran Reader.
abstract final class ReaderModalControllers {
  static void openTafsir({
    required BuildContext context,
    required SurahEntity surah,
    required AyahEntity ayah,
  }) {
    QuranTafsirReflectionSheet.show(
      context: context,
      surah: surah,
      ayah: ayah,
    );
  }

  static void openSurahQuickSwitch({
    required BuildContext context,
    required SurahEntity surah,
    required List<SurahEntity> allSurahs,
    required ValueChanged<SurahEntity>? onSurahChanged,
  }) {
    if (allSurahs.isEmpty || onSurahChanged == null) return;
    HapticService.selectionClick();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => QuranSurahQuickSwitchSheet(
        currentSurahId: surah.id,
        allSurahs: allSurahs,
        onSurahSelected: (selectedSurah) {
          Navigator.of(bottomSheetContext).pop();
          onSurahChanged.call(selectedSurah);
        },
      ),
    );
  }

  static void openSettings({
    required BuildContext context,
    required QuranReaderPreferences preferences,
    required ValueChanged<QuranReaderPreferences> onPreferencesChanged,
  }) {
    HapticService.selectionClick();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          return QuranReaderSettingsSheet(
            preferences: preferences,
            onPreferencesChanged: (newPrefs) {
              setModalState(() {});
              onPreferencesChanged(newPrefs);
            },
          );
        },
      ),
    );
  }

  static void toggleBookmark({
    required BuildContext context,
    required SurahEntity surah,
    required int activeAyah,
    required QuranReaderTheme activeTheme,
    required ValueChanged<QuranBookmarkEntity> onBookmarkSaved,
  }) {
    onBookmarkSaved(
      QuranBookmarkEntity(
        surahId: surah.id,
        surahName: surah.nameArabic,
        ayahNumber: activeAyah,
        pageNumber: surah.pageNumber,
        timestamp: DateTime.now(),
      ),
    );

    AppTopSnackBar.show(
      context: context,
      message:
          'تم تثبيت علامة الحفظ عند الآية $activeAyah من سورة ${surah.nameArabic} ✓',
      icon: Iconsax.bookmark,
      iconColor: activeTheme.accentColor,
      backgroundColor: activeTheme.cardColor,
      borderColor: activeTheme.accentColor,
      textColor: activeTheme.textColor,
    );
  }

  static void copyAyahOrPage({
    required BuildContext context,
    required SurahEntity surah,
    required int? selectedAyahNumber,
    required AyahEntity activeAyahEntity,
    required List<AyahEntity> currentVerses,
    required int currentPageIndex,
    required int totalPages,
    required QuranReaderTheme activeTheme,
  }) {
    HapticService.selectionClick();

    if (selectedAyahNumber != null) {
      Clipboard.setData(
        ClipboardData(
          text:
              '«${activeAyahEntity.text}» [سورة ${surah.nameArabic}: ${activeAyahEntity.numberInSurah}]',
        ),
      );
      AppTopSnackBar.show(
        context: context,
        message: 'تم نسخ الآية الكريمة بنجاح ✓',
        icon: Iconsax.tick_circle,
        iconColor: activeTheme.accentColor,
        backgroundColor: activeTheme.cardColor,
        borderColor: activeTheme.accentColor,
        textColor: activeTheme.textColor,
      );
    } else {
      final pageVersesText = currentVerses
          .map((a) => '${a.text} (${a.numberInSurah})')
          .join(' ');
      Clipboard.setData(
        ClipboardData(
          text:
              '«$pageVersesText» [سورة ${surah.nameArabic} - ص ${currentPageIndex + 1}/$totalPages]',
        ),
      );
      AppTopSnackBar.show(
        context: context,
        message: 'تم نسخ آيات الصفحة بنجاح ✓',
        icon: Iconsax.tick_circle,
        iconColor: activeTheme.accentColor,
        backgroundColor: activeTheme.cardColor,
        borderColor: activeTheme.accentColor,
        textColor: activeTheme.textColor,
      );
    }
  }
}

