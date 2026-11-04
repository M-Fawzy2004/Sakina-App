/// Represents an Ayah designed for display and recitation in the Verse Card Maker.
class VerseCardItem {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final String theme;
  final int durationSeconds;

  const VerseCardItem({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.theme,
    required this.durationSeconds,
  });

  /// Curated selection of inspiring, emotionally comforting Quranic verses
  /// calibrated with realistic recitation durations for video syncing.
  static const List<VerseCardItem> curatedVerses = [
    VerseCardItem(
      surahNumber: 20,
      ayahNumber: 14,
      surahName: 'طه',
      ayahText:
          'إِنَّنِي أَنَا اللَّهُ لَا إِلَٰهَ إِلَّا أَنَا فَاعْبُدْنِي وَأَقِمِ الصَّلَاةَ لِذِكْرِي',
      theme: 'التوحيد والصلة بالله',
      durationSeconds: 15,
    ),
    VerseCardItem(
      surahNumber: 17,
      ayahNumber: 9,
      surahName: 'الإسراء',
      ayahText:
          'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ وَيُبَشِّرُ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا كَبِيرًا',
      theme: 'هداية القرآن والسكينة',
      durationSeconds: 22,
    ),
    VerseCardItem(
      surahNumber: 2,
      ayahNumber: 186,
      surahName: 'البقرة',
      ayahText:
          'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
      theme: 'القرب والدعاء المستجاب',
      durationSeconds: 18,
    ),
    VerseCardItem(
      surahNumber: 94,
      ayahNumber: 5,
      surahName: 'الشرح',
      ayahText: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      theme: 'البشارة وانفراج الكرب',
      durationSeconds: 11,
    ),
    VerseCardItem(
      surahNumber: 13,
      ayahNumber: 28,
      surahName: 'الرعد',
      ayahText:
          'الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      theme: 'طمأنينة القلوب بذكر الله',
      durationSeconds: 17,
    ),
    VerseCardItem(
      surahNumber: 39,
      ayahNumber: 53,
      surahName: 'الزمر',
      ayahText:
          'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا',
      theme: 'سعة الرحمة والمغفرة',
      durationSeconds: 24,
    ),
    VerseCardItem(
      surahNumber: 93,
      ayahNumber: 5,
      surahName: 'الضحى',
      ayahText: 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ',
      theme: 'العطاء والرضا الإلهي',
      durationSeconds: 9,
    ),
    VerseCardItem(
      surahNumber: 50,
      ayahNumber: 16,
      surahName: 'ق',
      ayahText:
          'وَلَقَدْ خَلَقْنَا الْإِنسَانَ وَنَعْلَمُ مَا تُوَسْوِسُ بِهِ نَفْسُهُ ۖ وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ',
      theme: 'معية الله وقربه من العبد',
      durationSeconds: 19,
    ),
    VerseCardItem(
      surahNumber: 21,
      ayahNumber: 87,
      surahName: 'الأنبياء',
      ayahText:
          'لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ ۝ فَاسْتَجَبْنَا لَهُ وَنَجَّيْنَاهُ مِنَ الْغَمِّ',
      theme: 'دعاء ذي النون وتفريج الهموم',
      durationSeconds: 21,
    ),
    VerseCardItem(
      surahNumber: 65,
      ayahNumber: 3,
      surahName: 'الطلاق',
      ayahText:
          'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ ۚ إِنَّ اللَّهَ بَالِغُ أَمْرِهِ',
      theme: 'التوكل واليقين بالله',
      durationSeconds: 14,
    ),
  ];

  /// Finds the index of the verse with duration closest to the target video length.
  static int findBestMatchingIndex(int targetSeconds) {
    if (curatedVerses.isEmpty) return 0;
    int bestIndex = 0;
    int minDiff = (curatedVerses.first.durationSeconds - targetSeconds).abs();
    for (int i = 1; i < curatedVerses.length; i++) {
      final diff = (curatedVerses[i].durationSeconds - targetSeconds).abs();
      if (diff < minDiff) {
        minDiff = diff;
        bestIndex = i;
      }
    }
    return bestIndex;
  }
}
