import 'package:equatable/equatable.dart';

/// Pure domain entity representing a single Surah recitation track.
class RecitationTrackEntity extends Equatable {
  final int id;
  final int reciterId;
  final String reciterName;
  final int surahId;
  final String surahNameArabic;
  final String styleDescription;
  final String audioUrl;
  final Duration duration;
  final String riwayah;

  const RecitationTrackEntity({
    required this.id,
    required this.reciterId,
    required this.reciterName,
    required this.surahId,
    required this.surahNameArabic,
    required this.styleDescription,
    required this.audioUrl,
    required this.duration,
    required this.riwayah,
  });

  @override
  List<Object?> get props => [
        id,
        reciterId,
        reciterName,
        surahId,
        surahNameArabic,
        styleDescription,
        audioUrl,
        duration,
        riwayah,
      ];
}

