import 'package:equatable/equatable.dart';

/// Pure domain entity encapsulating dynamic spiritual context for the sanctuary header.
class MaladhHeaderData extends Equatable {
  final String greetingTitle;
  final String greetingSubtitle;
  final String hijriDate;
  final String gregorianDate;
  final String dailyVerseText;
  final String dailyVerseSurah;
  final String dailyVerseAudioUrl;
  final String nextPrayerName;
  final String nextPrayerTimeRemaining;
  final int streakDays;

  const MaladhHeaderData({
    required this.greetingTitle,
    required this.greetingSubtitle,
    required this.hijriDate,
    required this.gregorianDate,
    required this.dailyVerseText,
    required this.dailyVerseSurah,
    this.dailyVerseAudioUrl = 'https://everyayah.com/data/Alafasy_128kbps/002001.mp3',
    required this.nextPrayerName,
    required this.nextPrayerTimeRemaining,
    required this.streakDays,
  });

  @override
  List<Object?> get props => [
        greetingTitle,
        greetingSubtitle,
        hijriDate,
        gregorianDate,
        dailyVerseText,
        dailyVerseSurah,
        dailyVerseAudioUrl,
        nextPrayerName,
        nextPrayerTimeRemaining,
        streakDays,
      ];
}

