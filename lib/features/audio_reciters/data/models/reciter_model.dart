import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';

class ReciterModel extends ReciterEntity {
  const ReciterModel({
    required super.id,
    required super.nameArabic,
    required super.englishName,
    super.photoUrl,
    required super.listenersCount,
    required super.formattedListeners,
    required super.revelationStyle,
    required super.riwayah,
    super.isFeatured = false,
    required super.availableSurahsCount,
    required super.categories,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as int,
      nameArabic: json['name_arabic'] as String,
      englishName: json['english_name'] as String,
      photoUrl: json['photo_url'] as String?,
      listenersCount: json['listeners_count'] as int? ?? 0,
      formattedListeners: json['formatted_listeners'] as String? ?? '0',
      revelationStyle: json['revelation_style'] as String? ?? 'ترتيل',
      riwayah: json['riwayah'] as String? ?? 'حفص عن عاصم',
      isFeatured: json['is_featured'] as bool? ?? false,
      availableSurahsCount: json['available_surahs_count'] as int? ?? 114,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_arabic': nameArabic,
      'english_name': englishName,
      'photo_url': photoUrl,
      'listeners_count': listenersCount,
      'formatted_listeners': formattedListeners,
      'revelation_style': revelationStyle,
      'riwayah': riwayah,
      'is_featured': isFeatured,
      'available_surahs_count': availableSurahsCount,
      'categories': categories,
    };
  }

  ReciterEntity toEntity() => ReciterEntity(
        id: id,
        nameArabic: nameArabic,
        englishName: englishName,
        photoUrl: photoUrl,
        listenersCount: listenersCount,
        formattedListeners: formattedListeners,
        revelationStyle: revelationStyle,
        riwayah: riwayah,
        isFeatured: isFeatured,
        availableSurahsCount: availableSurahsCount,
        categories: categories,
      );
}

