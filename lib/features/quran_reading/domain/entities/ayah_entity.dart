import 'package:equatable/equatable.dart';

/// Immutable domain entity representing a Quranic Ayah (Verse).
class AyahEntity extends Equatable {
  final int numberInSurah;
  final String text;
  final int page;
  final int juz;
  final bool isSajdah;
  final String? tafsir;
  final String? reflection;

  const AyahEntity({
    required this.numberInSurah,
    required this.text,
    required this.page,
    required this.juz,
    this.isSajdah = false,
    this.tafsir,
    this.reflection,
  });

  @override
  List<Object?> get props => [
        numberInSurah,
        text,
        page,
        juz,
        isSajdah,
        tafsir,
        reflection,
      ];
}

