import 'package:equatable/equatable.dart';

class WidgetHadithData extends Equatable {
  final int id;
  final String text;
  final String narrator;
  final String sourceBook;
  final String topic;

  const WidgetHadithData({
    required this.id,
    required this.text,
    required this.narrator,
    required this.sourceBook,
    required this.topic,
  });

  @override
  List<Object?> get props => [id, text, narrator, sourceBook, topic];
}

class WidgetPrayerItem extends Equatable {
  final String name;
  final String time;
  final bool isNext;

  const WidgetPrayerItem({
    required this.name,
    required this.time,
    required this.isNext,
  });

  @override
  List<Object?> get props => [name, time, isNext];
}

class WidgetPrayerData extends Equatable {
  final String cityName;
  final String hijriDate;
  final String gregorianDate;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingCountdown;
  final String previousPrayerName;
  final String previousPrayerTime;
  final List<WidgetPrayerItem> prayers;

  const WidgetPrayerData({
    required this.cityName,
    required this.hijriDate,
    required this.gregorianDate,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.remainingCountdown,
    required this.previousPrayerName,
    required this.previousPrayerTime,
    required this.prayers,
  });

  @override
  List<Object?> get props => [
        cityName,
        hijriDate,
        gregorianDate,
        nextPrayerName,
        nextPrayerTime,
        remainingCountdown,
        previousPrayerName,
        previousPrayerTime,
        prayers,
      ];
}

class WidgetQuranData extends Equatable {
  final String surahName;
  final int ayahNumber;
  final String arabicText;
  final String reflection;

  const WidgetQuranData({
    required this.surahName,
    required this.ayahNumber,
    required this.arabicText,
    required this.reflection,
  });

  @override
  List<Object?> get props => [surahName, ayahNumber, arabicText, reflection];
}

class WidgetTasbeehData extends Equatable {
  final String phrase;
  final String shortTitle;
  final String virtue;
  final int targetCount;

  const WidgetTasbeehData({
    required this.phrase,
    required this.shortTitle,
    required this.virtue,
    required this.targetCount,
  });

  @override
  List<Object?> get props => [phrase, shortTitle, virtue, targetCount];
}

