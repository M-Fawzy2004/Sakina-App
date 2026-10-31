/// High-performance Arabic text normalization utilities for Quran search & filters.
abstract final class ArabicTextUtils {
  static final RegExp _tashkeelRegex = RegExp(r'[\u064B-\u065F\u0670]');

  /// Removes all Arabic diacritics (Harakat / Tashkeel / Shadda / Tanwin).
  static String stripTashkeel(String input) {
    return input.replaceAll(_tashkeelRegex, '');
  }

  /// Normalizes Arabic text for tolerant search matching:
  /// - Strips Tashkeel
  /// - Unifies Alif forms (أ / إ / آ -> ا)
  /// - Unifies Taa Marbutah (ة -> ه)
  /// - Unifies Alif Maqsura (ى -> ي)
  static String normalize(String input) {
    return stripTashkeel(input)
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .trim()
        .toLowerCase();
  }
}

