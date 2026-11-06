import 'dart:async';
import 'package:location/location.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';

/// Contract for on-device GPS location detection.
abstract class GpsLocationService {
  Future<CityLocation?> determineGpsLocation();
}

/// Implementation using the [Location] package to query device satellite GPS coordinates.
class GpsLocationServiceImpl implements GpsLocationService {
  final Location _location;

  GpsLocationServiceImpl({Location? location})
      : _location = location ?? Location();

  @override
  Future<CityLocation?> determineGpsLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return null;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      final locationData = await _location.getLocation().timeout(
            const Duration(seconds: 12),
            onTimeout: () => throw TimeoutException('GPS Location timed out'),
          );

      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == 0.0 && lng == 0.0) {
        return null;
      }

      final resolvedCity = PrayerLocationCatalog.fromGps(
        latitude: lat,
        longitude: lng,
      );

      AppLogger.info(
        'GPS Location resolved: ${resolvedCity.displayName} ($lat, $lng)',
        'LOCATION',
      );

      return resolvedCity;
    } catch (e, st) {
      AppLogger.error('Failed to query GPS coordinates', e, st, 'LOCATION');
      return null;
    }
  }
}

