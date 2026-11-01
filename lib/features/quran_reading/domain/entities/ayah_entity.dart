import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';

/// Immutable domain entity representing a Quranic Ayah (Verse) with multi-calligraphy script and multi-tafsir support.
class AyahEntity extends Equatable {
  final int numberInSurah;
  final String text;
  final String? textUthmani;
  final String? textImlaei;
  final String? textIndoPak;
  final int page;
  final int juz;
  final bool isSajdah;
  final String? tafsir;
  final String? reflection;
  final List<TafsirEntity> tafsirs;

  const AyahEntity({
    required this.numberInSurah,
    required this.text,
    this.textUthmani,
    this.textImlaei,
    this.textIndoPak,
    required this.page,
    required this.juz,
    this.isSajdah = false,
    this.tafsir,
    this.reflection,
    this.tafsirs = const [],
  });

  /// Resolves the primary Tafsir text, prioritizing [tafsir] or the first entry in [tafsirs].
  String? get primaryTafsir {
    if (tafsir != null && tafsir!.trim().isNotEmpty) return tafsir;
    if (tafsirs.isNotEmpty) return tafsirs.first.text;
    return null;
  }

  /// Resolves the Ayah text based on the user's preferred Quranic calligraphy script.
  String textForStyle(QuranScriptStyle style) {
    switch (style) {
      case QuranScriptStyle.imlaei:
        return textImlaei ?? text;
      case QuranScriptStyle.indopak:
        return textIndoPak ?? textUthmani ?? text;
      case QuranScriptStyle.amiri:
      case QuranScriptStyle.uthmani:
        return textUthmani ?? text;
    }
  }

  /// Generates the direct deterministic EveryAyah MP3 streaming URL for this Ayah.
  String getAudioUrl(int surahNumber, [String reciterId = 'Alafasy_128kbps']) {
    final surahPadded = surahNumber.toString().padLeft(3, '0');
    final ayahPadded = numberInSurah.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$reciterId/$surahPadded$ayahPadded.mp3';
  }

  @override
  List<Object?> get props => [
        numberInSurah,
        text,
        textUthmani,
        textImlaei,
        textIndoPak,
        page,
        juz,
        isSajdah,
        tafsir,
        reflection,
        tafsirs,
      ];
}

