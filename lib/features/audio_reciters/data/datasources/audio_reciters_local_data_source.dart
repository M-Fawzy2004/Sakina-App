import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/features/audio_reciters/data/models/recitation_track_model.dart';
import 'package:sakina_app/features/audio_reciters/data/models/reciter_model.dart';

abstract interface class AudioRecitersLocalDataSource {
  Future<List<ReciterModel>> getReciters({String? category, String? query});
  Future<List<ReciterModel>> getFeaturedReciters();
  Future<ReciterModel> getFeaturedReciter();
  Future<List<RecitationTrackModel>> getReciterTracks(int reciterId);
  Future<RecitationTrackModel> getTrackById(int trackId);
}

class AudioRecitersLocalDataSourceImpl implements AudioRecitersLocalDataSource {
  static const List<ReciterModel> _reciters = [
    ReciterModel(
      id: 1,
      nameArabic: 'الشيخ عبد الباسط عبد الصمد',
      englishName: 'Abdul Basit Abdul Samad',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Abdul_Basit_%27Abd_us-Samad.jpg/480px-Abdul_Basit_%27Abd_us-Samad.jpg',
      listenersCount: 1578,
      formattedListeners: '1,578',
      revelationStyle: 'صَوْتُ مَكَّة • تِلَاوَةٌ خَاشِعَةٌ مُجَوَّدَةٌ',
      riwayah: 'حفص عن عاصم',
      isFeatured: true,
      availableSurahsCount: 114,
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة', 'رواية حفص'],
    ),
    ReciterModel(
      id: 2,
      nameArabic: 'الشيخ محمد صديق المنشاوي',
      englishName: 'Mohamed Siddiq El-Minshawi',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Mohamed_Siddiq_El-Minshawi.jpg/480px-Mohamed_Siddiq_El-Minshawi.jpg',
      listenersCount: 2410,
      formattedListeners: '2,410',
      revelationStyle: 'الصَّوْتُ البَاكِي • تَرْتِيلٌ خَاشِعٌ نَبِيلٌ',
      riwayah: 'حفص عن عاصم',
      isFeatured: true,
      availableSurahsCount: 114,
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة', 'رواية حفص'],
    ),
    ReciterModel(
      id: 3,
      nameArabic: 'الشيخ ماهر المعيقلي',
      englishName: 'Maher Al-Muaiqly',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Maher_Al_Mueaqly.jpg/480px-Maher_Al_Mueaqly.jpg',
      listenersCount: 1892,
      formattedListeners: '1,892',
      revelationStyle: 'إِمَامُ الحَرَمِ المَكِّيِّ • تَرْتِيلٌ عَذْبٌ سَرِيعٌ',
      riwayah: 'حفص عن عاصم',
      isFeatured: true,
      availableSurahsCount: 114,
      categories: ['الأكثر استماعاً', 'رواية حفص'],
    ),
    ReciterModel(
      id: 4,
      nameArabic: 'الشيخ محمود خليل الحصري',
      englishName: 'Mahmoud Khalil Al-Hussary',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Mahmoud_Khalil_Al-Hussary.jpg/480px-Mahmoud_Khalil_Al-Hussary.jpg',
      listenersCount: 1922,
      formattedListeners: '1,922',
      revelationStyle: 'شَيْخُ عُمُومِ المَقَارِئ • إِتْقَانُ أَحْكَامِ التَّجْوِيدِ',
      riwayah: 'حفص عن عاصم',
      isFeatured: true,
      availableSurahsCount: 114,
      categories: ['رواية حفص', 'تلاوات نادرة'],
    ),
    ReciterModel(
      id: 5,
      nameArabic: 'الشيخ مشاري راشد العفاسي',
      englishName: 'Mishary Rashid Alafasy',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Mishary_Rashid_Alafasy.jpg/480px-Mishary_Rashid_Alafasy.jpg',
      listenersCount: 2105,
      formattedListeners: '2,105',
      revelationStyle: 'تِلَاوَةٌ رَقِيقَةٌ آسِرَةٌ لِلْقُلُوبِ',
      riwayah: 'حفص عن عاصم',
      isFeatured: false,
      availableSurahsCount: 114,
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
    ),
    ReciterModel(
      id: 6,
      nameArabic: 'الشيخ مصطفى إسماعيل',
      englishName: 'Mustafa Ismail',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Mustafa_Ismail.jpg/480px-Mustafa_Ismail.jpg',
      listenersCount: 1340,
      formattedListeners: '1,340',
      revelationStyle: 'قَارِئُ المُلُوكِ • عِمْلَاقُ النَّغَمِ وَالمَقَامَاتِ',
      riwayah: 'حفص عن عاصم',
      isFeatured: false,
      availableSurahsCount: 114,
      categories: ['تلاوات نادرة'],
    ),
    ReciterModel(
      id: 7,
      nameArabic: 'الشيخ سعود الشريم',
      englishName: 'Saud Al-Shuraim',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Saud_Al-Shuraim.jpg/480px-Saud_Al-Shuraim.jpg',
      listenersCount: 1280,
      formattedListeners: '1,280',
      revelationStyle: 'خَطِيبُ الحَرَمِ المَكِّيِّ • تَرْتِيلٌ حَزِينٌ مُؤَثِّرٌ',
      riwayah: 'حفص عن عاصم',
      isFeatured: false,
      availableSurahsCount: 114,
      categories: ['الأكثر استماعاً', 'رواية حفص'],
    ),
    ReciterModel(
      id: 8,
      nameArabic: 'الشيخ علي عبد الله جابر',
      englishName: 'Ali Abdullah Jaber',
      photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Ali_Abdullah_Jaber.jpg/480px-Ali_Abdullah_Jaber.jpg',
      listenersCount: 1490,
      formattedListeners: '1,490',
      revelationStyle: 'تَرَاوِيحُ مَكَّةَ الخَالِدَة • تِلَاوَةٌ نَادِرَةٌ',
      riwayah: 'حفص عن عاصم',
      isFeatured: false,
      availableSurahsCount: 114,
      categories: ['تلاوات نادرة', 'التلاوات الخاشعة'],
    ),
  ];

  static const List<RecitationTrackModel> _tracks = [
    RecitationTrackModel(
      id: 101,
      reciterId: 2,
      reciterName: 'الشيخ محمد صديق المنشاوي',
      surahId: 12,
      surahNameArabic: 'سورة يوسف',
      styleDescription: 'سُورَةُ يُوسُفَ • تِلَاوَةٌ خَاشِعَةٌ نَادِرَةٌ',
      audioUrl: 'https://server10.mp3quran.net/minsh/012.mp3',
      duration: Duration(minutes: 32, seconds: 15),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 102,
      reciterId: 1,
      reciterName: 'الشيخ عبد الباسط عبد الصمد',
      surahId: 19,
      surahNameArabic: 'سورة مريم',
      styleDescription: 'سُورَةُ مَرْيَمَ • تِلَاوَةٌ مُجَوَّدَةٌ آسِرَةٌ',
      audioUrl: 'https://server7.mp3quran.net/basit/019.mp3',
      duration: Duration(minutes: 28, seconds: 40),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 103,
      reciterId: 1,
      reciterName: 'الشيph عبد الباسط عبد الصمد',
      surahId: 55,
      surahNameArabic: 'سورة الرحمن',
      styleDescription: 'سُورَةُ الرَّحْمَٰنِ • تِلَاوَةٌ بَدِيعَةٌ خَالِدَةٌ',
      audioUrl: 'https://server7.mp3quran.net/basit/055.mp3',
      duration: Duration(minutes: 19, seconds: 12),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 104,
      reciterId: 3,
      reciterName: 'الشيخ ماهر المعيقلي',
      surahId: 18,
      surahNameArabic: 'سورة الكهف',
      styleDescription: 'سُورَةُ الكَهْفِ • تَرْتِيلُ الحَرَمِ المَكِّيِّ',
      audioUrl: 'https://server12.mp3quran.net/maher/018.mp3',
      duration: Duration(minutes: 24, seconds: 50),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 105,
      reciterId: 4,
      reciterName: 'الشيخ محمود خليل الحصري',
      surahId: 67,
      surahNameArabic: 'سورة الملك',
      styleDescription: 'سُورَةُ المُلْكِ • تَرْتِيلٌ مُتْقَنٌ مُعَلِّمٌ',
      audioUrl: 'https://server13.mp3quran.net/husr/067.mp3',
      duration: Duration(minutes: 9, seconds: 45),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 106,
      reciterId: 5,
      reciterName: 'الشيخ مشاري راشد العفاسي',
      surahId: 36,
      surahNameArabic: 'سورة يس',
      styleDescription: 'سُورَةُ يس • تِلَاوَةٌ نَدِيَّةٌ هَادِئَةٌ',
      audioUrl: 'https://server8.mp3quran.net/afs/036.mp3',
      duration: Duration(minutes: 15, seconds: 30),
      riwayah: 'حفص عن عاصم',
    ),
    RecitationTrackModel(
      id: 107,
      reciterId: 6,
      reciterName: 'الشيخ مصطفى إسماعيل',
      surahId: 25,
      surahNameArabic: 'سورة الفرقان',
      styleDescription: 'سُورَةُ الفُرْقَانِ • نَوَادِرُ التَّجْوِيدِ الخَالِدَةِ',
      audioUrl: 'https://server8.mp3quran.net/mustafa/025.mp3',
      duration: Duration(minutes: 22, seconds: 18),
      riwayah: 'حفص عن عاصم',
    ),
  ];

  @override
  Future<List<ReciterModel>> getReciters({String? category, String? query}) async {
    try {
      var result = List<ReciterModel>.from(_reciters);

      if (category != null && category.isNotEmpty && category != 'الكل') {
        result = result.where((r) => r.categories.contains(category)).toList();
      }

      if (query != null && query.trim().isNotEmpty) {
        final cleanQuery = query.trim().toLowerCase();
        result = result.where((r) {
          final arabicMatch = r.nameArabic.toLowerCase().contains(cleanQuery);
          final englishMatch = r.englishName.toLowerCase().contains(cleanQuery);
          final styleMatch = r.revelationStyle.toLowerCase().contains(cleanQuery);
          return arabicMatch || englishMatch || styleMatch;
        }).toList();
      }

      return result;
    } catch (e) {
      throw CacheException(message: 'فشل تحميل قائمة القراء: $e');
    }
  }

  @override
  Future<List<ReciterModel>> getFeaturedReciters() async {
    try {
      final featuredList = _reciters.where((r) => r.isFeatured).toList();
      return featuredList.isNotEmpty ? featuredList : _reciters.take(4).toList();
    } catch (e) {
      throw CacheException(message: 'فشل استرجاع شيوخ التلاوة المميزين: $e');
    }
  }

  @override
  Future<ReciterModel> getFeaturedReciter() async {
    try {
      final featured = _reciters.firstWhere(
        (r) => r.isFeatured,
        orElse: () => _reciters.first,
      );
      return featured;
    } catch (e) {
      throw CacheException(message: 'فشل استرجاع شيخ اليوم: $e');
    }
  }

  @override
  Future<List<RecitationTrackModel>> getReciterTracks(int reciterId) async {
    try {
      final tracks = _tracks.where((t) => t.reciterId == reciterId).toList();
      if (tracks.isNotEmpty) {
        return tracks;
      }
      final reciter = _reciters.firstWhere((r) => r.id == reciterId, orElse: () => _reciters.first);
      return [
        RecitationTrackModel(
          id: reciterId * 1000 + 1,
          reciterId: reciter.id,
          reciterName: reciter.nameArabic,
          surahId: 1,
          surahNameArabic: 'سورة الفاتحة',
          styleDescription: '${reciter.nameArabic} • تِلَاوَةٌ عَذْبَةٌ خَاشِعَةٌ',
          audioUrl: 'https://server10.mp3quran.net/minsh/001.mp3',
          duration: const Duration(minutes: 1, seconds: 15),
          riwayah: reciter.riwayah,
        ),
      ];
    } catch (e) {
      throw CacheException(message: 'فشل استرجاع تلاوات القارئ: $e');
    }
  }

  @override
  Future<RecitationTrackModel> getTrackById(int trackId) async {
    try {
      final track = _tracks.firstWhere(
        (t) => t.id == trackId,
        orElse: () => _tracks.first,
      );
      return track;
    } catch (e) {
      throw CacheException(message: 'فشل استرجاع المقطع الصوتي: $e');
    }
  }
}
