import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';

/// Data Transfer Object representing the sanctuary header context with serialization support.
class MaladhHeaderModel extends MaladhHeaderData {
  const MaladhHeaderModel({
    required super.greetingTitle,
    required super.greetingSubtitle,
    required super.hijriDate,
    required super.gregorianDate,
    required super.dailyVerseText,
    required super.dailyVerseSurah,
    super.dailyVerseAudioUrl,
    required super.nextPrayerName,
    required super.nextPrayerTimeRemaining,
    required super.streakDays,
  });

  factory MaladhHeaderModel.fromJson(Map<String, dynamic> json) {
    return MaladhHeaderModel(
      greetingTitle: json['greeting_title'] as String,
      greetingSubtitle: json['greeting_subtitle'] as String,
      hijriDate: json['hijri_date'] as String,
      gregorianDate: json['gregorian_date'] as String,
      dailyVerseText: json['daily_verse_text'] as String,
      dailyVerseSurah: json['daily_verse_surah'] as String,
      dailyVerseAudioUrl: (json['daily_verse_audio_url'] as String?) ??
          'https://everyayah.com/data/Alafasy_128kbps/002001.mp3',
      nextPrayerName: json['next_prayer_name'] as String,
      nextPrayerTimeRemaining: json['next_prayer_time_remaining'] as String,
      streakDays: (json['streak_days'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting_title': greetingTitle,
      'greeting_subtitle': greetingSubtitle,
      'hijri_date': hijriDate,
      'gregorian_date': gregorianDate,
      'daily_verse_text': dailyVerseText,
      'daily_verse_surah': dailyVerseSurah,
      'daily_verse_audio_url': dailyVerseAudioUrl,
      'next_prayer_name': nextPrayerName,
      'next_prayer_time_remaining': nextPrayerTimeRemaining,
      'streak_days': streakDays,
    };
  }

  MaladhHeaderData toEntity() => this;
}

