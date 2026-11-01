import 'package:equatable/equatable.dart';

/// Pure domain entity representing a Quranic Reciter (القارئ).
/// Designed according to the Clean Architecture domain layer standards.
class ReciterEntity extends Equatable {
  final int id;
  final String nameArabic;
  final String englishName;
  final String? photoUrl;
  final int listenersCount;
  final String formattedListeners;
  final String revelationStyle;
  final String riwayah;
  final bool isFeatured;
  final int availableSurahsCount;
  final List<String> categories;
  final String serverUrl;
  final String avatarLetter;

  const ReciterEntity({
    required this.id,
    required this.nameArabic,
    required this.englishName,
    this.photoUrl,
    required this.listenersCount,
    required this.formattedListeners,
    required this.revelationStyle,
    required this.riwayah,
    this.isFeatured = false,
    required this.availableSurahsCount,
    required this.categories,
    this.serverUrl = '',
    this.avatarLetter = 'ق',
  });

  /// Convenience constructor matching the curated Reciter prompt specification.
  const ReciterEntity.curated({
    required int id,
    required String name,
    required String title,
    required String rewayah,
    required String serverUrl,
    required String avatarLetter,
    String englishName = '',
    String? photoUrl,
    int listenersCount = 1200,
    String formattedListeners = '1.2K',
    bool isFeatured = true,
    int availableSurahsCount = 114,
    List<String> categories = const ['الأكثر استماعاً', 'رواية حفص'],
  }) : this(
          id: id,
          nameArabic: name,
          englishName: englishName,
          photoUrl: photoUrl,
          listenersCount: listenersCount,
          formattedListeners: formattedListeners,
          revelationStyle: title,
          riwayah: rewayah,
          isFeatured: isFeatured,
          availableSurahsCount: availableSurahsCount,
          categories: categories,
          serverUrl: serverUrl,
          avatarLetter: avatarLetter,
        );

  /// Convenience alias getters matching user specification
  String get name => nameArabic;
  String get title => revelationStyle;
  String get rewayah => riwayah;

  /// Top curated reciters defined by the Islamic Sanctuary standard.
  static const List<ReciterEntity> topReciters = [
    ReciterEntity.curated(
      id: 1,
      name: 'عبد الباسط عبد الصمد',
      title: 'صوت مكة • تلاوة مجودة',
      rewayah: 'المصحف المجود',
      serverUrl: 'https://server7.mp3quran.net/basit/',
      avatarLetter: 'ع',
      englishName: 'Abdul Basit Abdul Samad',
      listenersCount: 1578,
      formattedListeners: '1,578',
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة', 'المصحف المجود'],
    ),
    ReciterEntity.curated(
      id: 2,
      name: 'محمد صديق المنشاوي',
      title: 'الصوت الباكي • ترتيل خاشع',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server10.mp3quran.net/minsh/',
      avatarLetter: 'ص',
      englishName: 'Mohamed Siddiq El-Minshawi',
      listenersCount: 2410,
      formattedListeners: '2,410',
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة', 'رواية حفص'],
    ),
    ReciterEntity.curated(
      id: 3,
      name: 'محمود خليل الحصري',
      title: 'شيخ عموم المقارئ المصرية',
      rewayah: 'حفص عن عاصم (مرتل)',
      serverUrl: 'https://server13.mp3quran.net/husr/',
      avatarLetter: 'ح',
      englishName: 'Mahmoud Khalil Al-Hussary',
      listenersCount: 1922,
      formattedListeners: '1,922',
      categories: ['رواية حفص', 'تلاوات نادرة'],
    ),
    ReciterEntity.curated(
      id: 4,
      name: 'مشاري راشد العفاسي',
      title: 'تلاوات هادئة وأداء عذب',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server8.mp3quran.net/afs/',
      avatarLetter: 'م',
      englishName: 'Mishary Rashid Alafasy',
      listenersCount: 2105,
      formattedListeners: '2,105',
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
    ),
    ReciterEntity.curated(
      id: 5,
      name: 'ماهر المعيقلي',
      title: 'إمام وخطيب المسجد الحرام',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server12.mp3quran.net/maher/',
      avatarLetter: 'م',
      englishName: 'Maher Al-Muaiqly',
      listenersCount: 1892,
      formattedListeners: '1,892',
      categories: ['الأكثر استماعاً', 'رواية حفص'],
    ),
    ReciterEntity.curated(
      id: 6,
      name: 'سعود الشريم',
      title: 'تلاوات الحرم المكي الشريف',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server7.mp3quran.net/shur/',
      avatarLetter: 'س',
      englishName: 'Saud Al-Shuraim',
      listenersCount: 1280,
      formattedListeners: '1,280',
      categories: ['الأكثر استماعاً', 'رواية حفص'],
    ),
    ReciterEntity.curated(
      id: 7,
      name: 'ياسر الدوسري',
      title: 'نبرة خاشعة ورنانة',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server11.mp3quran.net/yasser/',
      avatarLetter: 'ي',
      englishName: 'Yasser Al-Dosari',
      listenersCount: 1740,
      formattedListeners: '1,740',
      categories: ['الأكثر استماعاً', 'التلاوات الخاشعة'],
    ),
    ReciterEntity.curated(
      id: 8,
      name: 'سعد الغامدي',
      title: 'ترتيل عذب وسلس',
      rewayah: 'حفص عن عاصم',
      serverUrl: 'https://server7.mp3quran.net/s_gmd/',
      avatarLetter: 'غ',
      englishName: 'Saad Al-Ghamdi',
      listenersCount: 1630,
      formattedListeners: '1,630',
      categories: ['الأكثر استماعاً', 'رواية حفص'],
    ),
  ];

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        englishName,
        photoUrl,
        listenersCount,
        formattedListeners,
        revelationStyle,
        riwayah,
        isFeatured,
        availableSurahsCount,
        categories,
        serverUrl,
        avatarLetter,
      ];
}

/// Backward compatibility typedef
typedef Reciter = ReciterEntity;

/// Direct constant export matching user prompt
const List<ReciterEntity> topReciters = ReciterEntity.topReciters;
