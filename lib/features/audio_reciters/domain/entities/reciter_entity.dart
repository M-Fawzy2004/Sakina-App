import 'package:equatable/equatable.dart';

/// Pure domain entity representing a Quranic Reciter (القارئ).
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
  });

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
      ];
}

