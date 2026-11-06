import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';
import 'package:sakina_app/features/maladh/domain/services/global_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_location_selector_sheet.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_times_detail/prayer_calendar_date_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_times_detail/prayer_next_countdown_card.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_times_detail/prayer_times_detail_header.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_times_detail/prayer_times_full_list_card.dart';

/// Full-screen comprehensive prayer times and celestial schedule dashboard.
class PrayerTimesDetailScreen extends StatefulWidget {
  const PrayerTimesDetailScreen({super.key});

  /// Opens the screen cleanly with safe root navigator push.
  static Future<void> open(BuildContext context) {
    HapticService.selectionClick();
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const PrayerTimesDetailScreen(),
      ),
    );
  }

  @override
  State<PrayerTimesDetailScreen> createState() => _PrayerTimesDetailScreenState();
}

class _PrayerTimesDetailScreenState extends State<PrayerTimesDetailScreen> {
  late CityLocation _currentCity;
  DateTime _now = DateTime.now();
  Timer? _minuteTicker;

  @override
  void initState() {
    super.initState();
    final prefs = sl.isRegistered<PreferencesService>()
        ? sl<PreferencesService>()
        : null;
    _currentCity = PrayerLocationCatalog.getEffectiveLocation(prefs);

    // Refresh every minute to keep bounding prayers and day accurate
    _minuteTicker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _minuteTicker?.cancel();
    super.dispose();
  }

  Future<void> _handleLocationChange() async {
    final picked = await PrayerLocationSelectorSheet.show(
      context,
      currentCity: _currentCity,
    );
    if (picked != null && mounted) {
      setState(() => _currentCity = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final prefs = sl.isRegistered<PreferencesService>()
        ? sl<PreferencesService>()
        : null;
    final scheduleInfo = GlobalPrayerTimesCalculator.calculate(
      location: _currentCity,
      prefs: prefs,
      customNow: _now,
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Standard Sakina Luxury Header with City Title & Location Action
            PrayerTimesDetailHeader(
              cityName: _currentCity.cityNameArabic,
              onBackTap: () => Navigator.of(context).pop(),
              onLocationTap: _handleLocationChange,
            ),

            // 2. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  children: [
                    // A. Calendar & Celestial Date Card
                    PrayerCalendarDateCard(now: _now),

                    // B. Next Prayer Banner with Live Countdown Ticker
                    PrayerNextCountdownCard(scheduleInfo: scheduleInfo),

                    // C. Detailed 6-slot Prayer Times List with Iqamah
                    PrayerTimesFullListCard(
                      scheduleInfo: scheduleInfo,
                      now: _now,
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

