/// Utility for formatting numbers and strings to Eastern Arabic numerals (الأرقام المشرقية).
abstract final class ArabicNumerals {
  static const List<String> _arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Converts any integer or numeric string to classical Arabic digits.
  static String format(dynamic value) {
    if (value == null) return '';
    final str = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      final digit = int.tryParse(char);
      if (digit != null && digit >= 0 && digit <= 9) {
        buffer.write(_arabicDigits[digit]);
      } else {
        buffer.write(char);
      }
    }

    return buffer.toString();
  }
}

