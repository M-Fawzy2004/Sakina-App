/// Data model for an inspiring Quranic reflection notification.
class QuranReflectionItem {
  final int id;
  final String surahName;
  final int ayahNumber;
  final String verseText;

  const QuranReflectionItem({
    required this.id,
    required this.surahName,
    required this.ayahNumber,
    required this.verseText,
  });

  String get notificationTitle => 'نفحة قرآنية • سورة $surahName';
  String get notificationBody => '«$verseText» [الآية $ayahNumber]';
}

/// Curated pool of 60 deeply comforting, spiritually uplifting Quranic verses
/// for spaced non-repeating daily notifications across morning, afternoon, and evening.
/// Strictly zero emojis in accordance with Sakina brand guidelines.
abstract final class QuranReflectionsCatalog {
  static const List<QuranReflectionItem> pool = [
    QuranReflectionItem(
      id: 1,
      surahName: 'البقرة',
      ayahNumber: 186,
      verseText:
          'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
    ),
    QuranReflectionItem(
      id: 2,
      surahName: 'الشرح',
      ayahNumber: 5,
      verseText: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
    ),
    QuranReflectionItem(
      id: 3,
      surahName: 'الرعد',
      ayahNumber: 28,
      verseText:
          'الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
    ),
    QuranReflectionItem(
      id: 4,
      surahName: 'الزمر',
      ayahNumber: 53,
      verseText:
          'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا',
    ),
    QuranReflectionItem(
      id: 5,
      surahName: 'الضحى',
      ayahNumber: 5,
      verseText: 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ',
    ),
    QuranReflectionItem(
      id: 6,
      surahName: 'ق',
      ayahNumber: 16,
      verseText: 'وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ',
    ),
    QuranReflectionItem(
      id: 7,
      surahName: 'الأنبياء',
      ayahNumber: 87,
      verseText:
          'لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ ۝ فَاسْتَجَبْنَا لَهُ وَنَجَّيْنَاهُ مِنَ الْغَمِّ',
    ),
    QuranReflectionItem(
      id: 8,
      surahName: 'الطلاق',
      ayahNumber: 3,
      verseText:
          'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ ۚ إِنَّ اللَّهَ بَالِغُ أَمْرِهِ',
    ),
    QuranReflectionItem(
      id: 9,
      surahName: 'طه',
      ayahNumber: 14,
      verseText:
          'إِنَّنِي أَنَا اللَّهُ لَا إِلَٰهَ إِلَّا أَنَا فَاعْبُدْنِي وَأَقِمِ الصَّلَاةَ لِذِكْرِي',
    ),
    QuranReflectionItem(
      id: 10,
      surahName: 'الإسراء',
      ayahNumber: 9,
      verseText:
          'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ وَيُبَشِّرُ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا كَبِيرًا',
    ),
    QuranReflectionItem(
      id: 11,
      surahName: 'يوسف',
      ayahNumber: 86,
      verseText: 'إِنَّمَا أَشْكُو بَثِّي وَحُزْنِي إِلَى اللَّهِ',
    ),
    QuranReflectionItem(
      id: 12,
      surahName: 'إبراهيم',
      ayahNumber: 7,
      verseText: 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
    ),
    QuranReflectionItem(
      id: 13,
      surahName: 'النحل',
      ayahNumber: 128,
      verseText: 'إِنَّ اللَّهَ مَعَ الَّذِينَ اتَّقَوا وَّالَّذِينَ هُم مُّحْسِنُونَ',
    ),
    QuranReflectionItem(
      id: 14,
      surahName: 'هود',
      ayahNumber: 88,
      verseText: 'وَمَا تَوْفِيقِي إِلَّا بِاللَّهِ ۚ عَلَيْهِ تَوَكَّلْتُ وَإِلَيْهِ أُنِيبُ',
    ),
    QuranReflectionItem(
      id: 15,
      surahName: 'البقرة',
      ayahNumber: 286,
      verseText: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
    ),
    QuranReflectionItem(
      id: 16,
      surahName: 'طه',
      ayahNumber: 46,
      verseText: 'قَالَ لَا تَخَافَا ۖ إِنَّنِي مَعَكُمَا أَسْمَعُ وَأَرَىٰ',
    ),
    QuranReflectionItem(
      id: 17,
      surahName: 'التوبة',
      ayahNumber: 40,
      verseText: 'لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا',
    ),
    QuranReflectionItem(
      id: 18,
      surahName: 'آل عمران',
      ayahNumber: 139,
      verseText:
          'وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنتُمُ الْأَعْلَوْنَ إِن كُنتُم مُّؤْمِنِينَ',
    ),
    QuranReflectionItem(
      id: 19,
      surahName: 'البقرة',
      ayahNumber: 152,
      verseText: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
    ),
    QuranReflectionItem(
      id: 20,
      surahName: 'الفجر',
      ayahNumber: 27,
      verseText:
          'يَا أَيَّتُهَا النَّفْسُ الْمُطْمَئِنَّةُ ۝ ارْجِعِي إِلَىٰ رَبِّكِ رَاضِيَةً مَّرْضِيَّةً',
    ),
    QuranReflectionItem(
      id: 21,
      surahName: 'النمل',
      ayahNumber: 62,
      verseText: 'أَمَّن يُجِيبُ الْمُضْطَرَّ إِذَا دَعَاهُ وَيَكْشِفُ السُّوءَ',
    ),
    QuranReflectionItem(
      id: 22,
      surahName: 'الأنبياء',
      ayahNumber: 83,
      verseText: 'أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ',
    ),
    QuranReflectionItem(
      id: 23,
      surahName: 'غافر',
      ayahNumber: 60,
      verseText: 'وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ',
    ),
    QuranReflectionItem(
      id: 24,
      surahName: 'يونس',
      ayahNumber: 107,
      verseText: 'وَإِن يَمْسَسْكَ اللَّهُ بِضُرٍّ فَلَا كَاشِفَ لَهُ إِلَّا هُوَ',
    ),
    QuranReflectionItem(
      id: 25,
      surahName: 'مريم',
      ayahNumber: 96,
      verseText:
          'إِنَّ الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ سَيَجْعَلُ لَهُمُ الرَّحْمَٰنُ وُدًّا',
    ),
    QuranReflectionItem(
      id: 26,
      surahName: 'التوبة',
      ayahNumber: 129,
      verseText:
          'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    ),
    QuranReflectionItem(
      id: 27,
      surahName: 'الفرقان',
      ayahNumber: 58,
      verseText: 'وَتَوَكَّلْ عَلَى الْحَيِّ الَّذِي لَا يَمُوتُ وَسَبِّحْ بِحَمْدِهِ',
    ),
    QuranReflectionItem(
      id: 28,
      surahName: 'الأنفال',
      ayahNumber: 70,
      verseText:
          'إِن يَعْلَمِ اللَّهُ فِي قُلُوبِكُمْ خَيْرًا يُؤْتِكُمْ خَيْرًا مِّمَّا أُخِذَ مِنكُمْ',
    ),
    QuranReflectionItem(
      id: 29,
      surahName: 'فاطر',
      ayahNumber: 2,
      verseText: 'مَّا يَفْتَحِ اللَّهُ لِلنَّاسِ مِن رَّحْمَةٍ فَلَا مُمْسِكَ لَهَا',
    ),
    QuranReflectionItem(
      id: 30,
      surahName: 'النور',
      ayahNumber: 35,
      verseText: 'اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ',
    ),
    QuranReflectionItem(
      id: 31,
      surahName: 'الحشر',
      ayahNumber: 23,
      verseText:
          'هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْمَلِكُ الْقُدُّوسُ السَّلَامُ الْمُؤْمِنُ الْمُهَيْمِنُ',
    ),
    QuranReflectionItem(
      id: 32,
      surahName: 'الحديد',
      ayahNumber: 4,
      verseText: 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ ۚ وَاللَّهُ بِمَا تَعْمَلُونَ بَصِيرٌ',
    ),
    QuranReflectionItem(
      id: 33,
      surahName: 'الإنسان',
      ayahNumber: 3,
      verseText: 'إِنَّا هَدَيْنَاهُ السَّبِيلَ إِمَّا شَاكِرًا وَإِمَّا كَفُورًا',
    ),
    QuranReflectionItem(
      id: 34,
      surahName: 'البلد',
      ayahNumber: 4,
      verseText: 'لَقَدْ خَلَقْنَا الْإِنسَانَ فِي كَبَدٍ',
    ),
    QuranReflectionItem(
      id: 35,
      surahName: 'الشمس',
      ayahNumber: 9,
      verseText: 'قَدْ أَفْلَحَ مَن زَكَّاهَا',
    ),
    QuranReflectionItem(
      id: 36,
      surahName: 'الليل',
      ayahNumber: 7,
      verseText:
          'فَأَمَّا مَنْ أَعْطَىٰ وَاتَّقَىٰ ۝ وَصَدَّقَ بِالْحُسْنَىٰ ۝ فَسَنُيَسِّرُهُ لِلْيُسْرَىٰ',
    ),
    QuranReflectionItem(
      id: 37,
      surahName: 'الحجر',
      ayahNumber: 98,
      verseText:
          'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَكُن مِّنَ السَّاجِدِينَ ۝ وَاعْبُدْ رَبَّكَ حَتَّىٰ يَأْتِيَكَ الْيَقِينُ',
    ),
    QuranReflectionItem(
      id: 38,
      surahName: 'الأحقاف',
      ayahNumber: 13,
      verseText:
          'إِنَّ الَّذِينَ قَالُوا رَبُّنَا اللَّهُ ثُمَّ اسْتَقَامُوا فَلَا خَوْفٌ عَلَيْهِمْ وَلَا هُمْ يَحْزَنُونَ',
    ),
    QuranReflectionItem(
      id: 39,
      surahName: 'الفتح',
      ayahNumber: 4,
      verseText:
          'هُوَ الَّذِي أَنزَلَ السَّكِينَةَ فِي قُلُوبِ الْمُؤْمِنِينَ لِيَزْدَادُوا إِيمَانًا مَّعَ إِيمَانِهِمْ',
    ),
    QuranReflectionItem(
      id: 40,
      surahName: 'يوسف',
      ayahNumber: 87,
      verseText: 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ',
    ),
    QuranReflectionItem(
      id: 41,
      surahName: 'يوسف',
      ayahNumber: 90,
      verseText: 'إِنَّهُ مَن يَتَّقِ وَيَصْبِرْ فَإِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
    ),
    QuranReflectionItem(
      id: 42,
      surahName: 'الكهف',
      ayahNumber: 10,
      verseText: 'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
    ),
    QuranReflectionItem(
      id: 43,
      surahName: 'الكهف',
      ayahNumber: 24,
      verseText:
          'وَاذْكُر رَّبَّكَ إِذَا نَسِيتَ وَقُلْ عَسَىٰ أَن يَهْدِيَنِ رَبِّي لِأَقْرَبَ مِنْ هَٰذَا رَشَدًا',
    ),
    QuranReflectionItem(
      id: 44,
      surahName: 'مريم',
      ayahNumber: 65,
      verseText: 'رَّبُّ السَّمَاوَاتِ وَالْأَرْضِ وَمَا بَيْنَهُمَا فَاعْبُدْهُ وَاصْطَبِرْ لِعِبَادَتِهِ',
    ),
    QuranReflectionItem(
      id: 45,
      surahName: 'طه',
      ayahNumber: 25,
      verseText:
          'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي ۝ يَفْقَهُوا قَوْلِي',
    ),
    QuranReflectionItem(
      id: 46,
      surahName: 'الأنبياء',
      ayahNumber: 89,
      verseText: 'رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنتَ خَيْرُ الْوَارِثِينَ',
    ),
    QuranReflectionItem(
      id: 47,
      surahName: 'المؤمنون',
      ayahNumber: 118,
      verseText: 'وَقُل رَّبِّ اغْفِرْ وَارْحَمْ وَأَنتَ خَيْرُ الرَّاحِمِينَ',
    ),
    QuranReflectionItem(
      id: 48,
      surahName: 'النمل',
      ayahNumber: 19,
      verseText:
          'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ',
    ),
    QuranReflectionItem(
      id: 49,
      surahName: 'القصص',
      ayahNumber: 24,
      verseText: 'رَبِّ إِنِّي لِمَا أَنزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
    ),
    QuranReflectionItem(
      id: 50,
      surahName: 'العنكبوت',
      ayahNumber: 69,
      verseText:
          'وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا ۚ وَإِنَّ اللَّهَ لَمَعَ الْمُحْسِنِينَ',
    ),
    QuranReflectionItem(
      id: 51,
      surahName: 'الروم',
      ayahNumber: 21,
      verseText:
          'وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً',
    ),
    QuranReflectionItem(
      id: 52,
      surahName: 'لقمان',
      ayahNumber: 17,
      verseText:
          'يَا بُنَيَّ أَقِمِ الصَّلَاةَ وَأْمُرْ بِالْمَعْرُوفِ وَانْهَ عَنِ الْمُنكَرِ وَاصْبِرْ عَلَىٰ مَا أَصَابَكَ',
    ),
    QuranReflectionItem(
      id: 53,
      surahName: 'السجدة',
      ayahNumber: 17,
      verseText:
          'فَلَا تَعْلَمُ نَفْسٌ مَّا أُخْفِيَ لَهُم مِّن قُرَّةِ أَعْيُنٍ جَزَاءً بِمَا كَانُوا يَعْمَلُونَ',
    ),
    QuranReflectionItem(
      id: 54,
      surahName: 'يس',
      ayahNumber: 58,
      verseText: 'سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ',
    ),
    QuranReflectionItem(
      id: 55,
      surahName: 'الصافات',
      ayahNumber: 181,
      verseText: 'وَسَلَامٌ عَلَى الْمُرْسَلِينَ ۝ وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    ),
    QuranReflectionItem(
      id: 56,
      surahName: 'فصلت',
      ayahNumber: 30,
      verseText:
          'إِنَّ الَّذِينَ قَالُوا رَبُّنَا اللَّهُ ثُمَّ اسْتَقَامُوا تَتَنَزَّلُ عَلَيْهِمُ الْمَلَائِكَةُ أَلَّا تَخَافُوا وَلَا تَحْزَنُوا',
    ),
    QuranReflectionItem(
      id: 57,
      surahName: 'الشورى',
      ayahNumber: 19,
      verseText: 'اللَّهُ لَطِيفٌ بِعِبَادِهِ يَرْزُقُ مَن يَشَاءُ ۖ وَهُوَ الْقَوِيُّ الْعَزِيزُ',
    ),
    QuranReflectionItem(
      id: 58,
      surahName: 'ق',
      ayahNumber: 39,
      verseText: 'فَاصْبِرْ عَلَىٰ مَا يَقُولُونَ وَسَبِّحْ بِحَمْدِ رَبِّكَ',
    ),
    QuranReflectionItem(
      id: 59,
      surahName: 'البقرة',
      ayahNumber: 45,
      verseText:
          'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى الْخَاشِعِينَ',
    ),
    QuranReflectionItem(
      id: 60,
      surahName: 'الفرقان',
      ayahNumber: 74,
      verseText:
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
    ),
  ];
}

