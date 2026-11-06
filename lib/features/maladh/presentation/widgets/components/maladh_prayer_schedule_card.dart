import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/location/gps_location_service.dart';
import 'package:sakina_app/core/services/notifications/local_notification_service.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';
import 'package:sakina_app/features/maladh/domain/services/cairo_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/global_prayer_times_calculator.dart';
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/prayer_location_selector_sheet.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/prayer_times_detail_screen.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';

/// "جدول الصلوات اليومية" - Worldwide offline prayer schedule card.
/// Displays:
/// 1. Top interactive city/country selector bar.
/// 2. The 5 daily Fard prayers with custom iconography and active prayer highlight.
/// 3. Supplementary celestial times (الشروق • منتصف الليل • الثلث الأخير).
class MaladhPrayerScheduleCard extends StatefulWidget {
  final String? hijriDate;
  final String? nextPrayerName;
  final VoidCallback? onPrayerTap;

  const MaladhPrayerScheduleCard({
    super.key,
    this.hijriDate,
    this.nextPrayerName,
    this.onPrayerTap,
  });

  @override
  State<MaladhPrayerScheduleCard> createState() =>
      _MaladhPrayerScheduleCardState();
}

class _MaladhPrayerScheduleCardState extends State<MaladhPrayerScheduleCard> {
  late CityLocation _currentCity;
  bool _isDetectingGps = false;

  @override
  void initState() {
    super.initState();
    final prefs = sl.isRegistered<PreferencesService>()
        ? sl<PreferencesService>()
        : null;
    _currentCity = PrayerLocationCatalog.findFromPreferences(prefs);
  }

  Future<void> _handleGpsAutoDetect() async {
    HapticService.selectionClick();
    setState(() => _isDetectingGps = true);

    if (!sl.isRegistered<GpsLocationService>()) {
      if (mounted) setState(() => _isDetectingGps = false);
      return;
    }

    final gpsService = sl<GpsLocationService>();
    final resolvedCity = await gpsService.determineGpsLocation();

    if (!mounted) return;
    setState(() => _isDetectingGps = false);

    if (resolvedCity != null) {
      final prefs = sl.isRegistered<PreferencesService>()
          ? sl<PreferencesService>()
          : null;
      if (prefs != null) {
        await prefs.setString(
          PrayerLocationCatalog.keySelectedCityId,
          resolvedCity.id,
        );
        if (sl.isRegistered<LocalNotificationService>()) {
          final notif = sl<LocalNotificationService>();
          final enabled = prefs.getBool(
                SettingsPersistenceManager.keyPrePrayerReminder,
              ) ??
              true;
          unawaited(
            notif.schedulePrePrayerReminders(
              enabled: enabled,
              prefs: prefs,
            ),
          );
        }
      }
      if (!mounted) return;
      setState(() => _currentCity = resolvedCity);
      AppTopSnackBar.showSuccess(
        context: context,
        message: 'تم تحديد موقعك بدقة (GPS): ${resolvedCity.displayName}',
      );
    } else {
      if (!mounted) return;
      AppTopSnackBar.show(
        context: context,
        message: 'تعذر جلب موقع GPS؛ يرجى التأكد من تشغيل خدمات الموقع بهاتفك',
      );
    }
  }

  Future<void> _changeLocation() async {
    final pickedCity = await PrayerLocationSelectorSheet.show(
      context,
      currentCity: _currentCity,
    );
    if (pickedCity != null && mounted) {
      setState(() => _currentCity = pickedCity);
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
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.6),
            width: 0.8.r,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 0. Dedicated Location & GPS Bar (Athkar Style)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              color: colors.background.withValues(alpha: 0.45),
              child: Row(
                children: [
                  // City & Country Title
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.location5,
                          size: 15.r,
                          color: colors.accentGold,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            _currentCity.displayName,
                            style: GoogleFonts.cairo(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // One-tap GPS Auto-detect Button
                  InkWell(
                    onTap: _isDetectingGps ? null : _handleGpsAutoDetect,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.accentGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: colors.accentGold.withValues(alpha: 0.35),
                          width: 0.8.r,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isDetectingGps)
                            SizedBox(
                              width: 12.r,
                              height: 12.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5.r,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.accentGold,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Iconsax.gps,
                              size: 13.r,
                              color: colors.accentGold,
                            ),
                          SizedBox(width: 4.w),
                          Text(
                            _isDetectingGps ? 'جارٍ التحديد...' : 'تحديد بالـ GPS',
                            style: GoogleFonts.cairo(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  // Manual Selector Button
                  InkWell(
                    onTap: _changeLocation,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 3.5.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تغيير',
                            style: GoogleFonts.cairo(
                              fontSize: 10.5.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 14.r,
                            color: colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top hairline divider
            Container(
              height: 0.8.h,
              color: colors.borderHairline.withValues(alpha: 0.35),
            ),

            // 1. Five Daily Fard Prayers Row (الفجر، الظهر، العصر، المغرب، العشاء)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: _MainPrayersRow(
                activePrayerIndex: scheduleInfo.nextPrayerIndex,
                scheduleInfo: scheduleInfo,
              ),
            ),

            // 2. Hairline Divider
            Container(
              height: 1.h,
              color: colors.borderHairline.withValues(alpha: 0.35),
            ),

            // 3. Supplementary Sunnah Celestial Times (الشروق، منتصف الليل، الثلث الأخير)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: _SupplementaryTimesRow(
                sunriseTime: scheduleInfo.sunriseFormatted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Five Fard Prayers Grid Row with dynamic times.
class _MainPrayersRow extends StatelessWidget {
  final int activePrayerIndex;
  final PrayerScheduleInfo scheduleInfo;

  const _MainPrayersRow({
    required this.activePrayerIndex,
    required this.scheduleInfo,
  });

  @override
  Widget build(BuildContext context) {
    final prayers = [
      (
        name: 'الفجر',
        time: scheduleInfo.fajrFormatted,
        icon: Icons.wb_twilight_rounded
      ),
      (
        name: 'الظهر',
        time: scheduleInfo.dhuhrFormatted,
        icon: Icons.wb_sunny_rounded
      ),
      (
        name: 'العصر',
        time: scheduleInfo.asrFormatted,
        icon: Iconsax.cloud_sunny
      ),
      (
        name: 'المغرب',
        time: scheduleInfo.maghribFormatted,
        icon: Icons.wb_twilight_rounded
      ),
      (
        name: 'العشاء',
        time: scheduleInfo.ishaFormatted,
        icon: Iconsax.moon
      ),
    ];

    return Row(
      children: List.generate(prayers.length, (index) {
        final p = prayers[index];
        final isNext = index == activePrayerIndex;
        return Expanded(
          child: _SinglePrayerSlot(
            name: p.name,
            time: p.time,
            icon: p.icon,
            isNext: isNext,
          ),
        );
      }),
    );
  }
}

/// Individual column representing a single prayer time slot.
class _SinglePrayerSlot extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;

  const _SinglePrayerSlot({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryColor = isNext ? colors.accentGold : colors.textPrimary;
    final subtitleColor = isNext ? colors.accentGold : colors.textSecondary;

    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        PrayerTimesDetailScreen.open(context);
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: GoogleFonts.cairo(
                color: subtitleColor,
                fontSize: 11.sp,
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 5.h),
            Icon(icon, size: 20.r, color: primaryColor),
            SizedBox(height: 5.h),
            Text(
              time,
              style: GoogleFonts.cairo(
                color: primaryColor,
                fontSize: 12.sp,
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w700,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Supplementary Celestial Times Row (الشروق • منتصف الليل • الثلث الأخير).
class _SupplementaryTimesRow extends StatelessWidget {
  final String sunriseTime;

  const _SupplementaryTimesRow({
    required this.sunriseTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () {
        HapticService.selectionClick();
        PrayerTimesDetailScreen.open(context);
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Row(
        children: [
        Expanded(
          child: _SupplementaryTimeItem(
            name: 'الشروق',
            time: sunriseTime,
          ),
        ),
        Container(
          width: 1.w,
          height: 22.h,
          color: colors.borderHairline.withValues(alpha: 0.35),
        ),
        const Expanded(
          child: _SupplementaryTimeItem(
            name: 'منتصف الليل',
            time: '11:15',
          ),
        ),
        Container(
          width: 1.w,
          height: 22.h,
          color: colors.borderHairline.withValues(alpha: 0.35),
        ),
        const Expanded(
          child: _SupplementaryTimeItem(
            name: 'الثلث الأخير',
            time: '1:45',
          ),
        ),
      ],
      ),
    );
  }
}

class _SupplementaryTimeItem extends StatelessWidget {
  final String name;
  final String time;

  const _SupplementaryTimeItem({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: GoogleFonts.cairo(
            color: colors.textSecondary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          time,
          style: GoogleFonts.cairo(
            color: colors.textPrimary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
