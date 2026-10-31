import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';

class RecitationTrackModel extends RecitationTrackEntity {
  const RecitationTrackModel({
    required super.id,
    required super.reciterId,
    required super.reciterName,
    required super.surahId,
    required super.surahNameArabic,
    required super.styleDescription,
    required super.audioUrl,
    required super.duration,
    required super.riwayah,
  });

  factory RecitationTrackModel.fromJson(Map<String, dynamic> json) {
    return RecitationTrackModel(
      id: json['id'] as int,
      reciterId: json['reciter_id'] as int,
      reciterName: json['reciter_name'] as String,
      surahId: json['surah_id'] as int,
      surahNameArabic: json['surah_name_arabic'] as String,
      styleDescription: json['style_description'] as String,
      audioUrl: json['audio_url'] as String,
      duration: Duration(seconds: json['duration_seconds'] as int? ?? 0),
      riwayah: json['riwayah'] as String? ?? 'حفص عن عاصم',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reciter_id': reciterId,
      'reciter_name': reciterName,
      'surah_id': surahId,
      'surah_name_arabic': surahNameArabic,
      'style_description': styleDescription,
      'audio_url': audioUrl,
      'duration_seconds': duration.inSeconds,
      'riwayah': riwayah,
    };
  }

  RecitationTrackEntity toEntity() => RecitationTrackEntity(
        id: id,
        reciterId: reciterId,
        reciterName: reciterName,
        surahId: surahId,
        surahNameArabic: surahNameArabic,
        styleDescription: styleDescription,
        audioUrl: audioUrl,
        duration: duration,
        riwayah: riwayah,
      );
}

