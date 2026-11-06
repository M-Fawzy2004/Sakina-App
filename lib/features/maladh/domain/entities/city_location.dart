import 'package:equatable/equatable.dart';

/// Pure domain entity representing a worldwide geographic location for astronomical prayer times.
class CityLocation extends Equatable {
  final String id;
  final String cityNameArabic;
  final String countryNameArabic;
  final String countryCode;
  final double latitude;
  final double longitude;
  final double utcOffsetHours;
  final String calculationMethod;

  const CityLocation({
    required this.id,
    required this.cityNameArabic,
    required this.countryNameArabic,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.utcOffsetHours,
    required this.calculationMethod,
  });

  String get displayName => '$cityNameArabic، $countryNameArabic';

  @override
  List<Object?> get props => [
        id,
        cityNameArabic,
        countryNameArabic,
        countryCode,
        latitude,
        longitude,
        utcOffsetHours,
        calculationMethod,
      ];
}

