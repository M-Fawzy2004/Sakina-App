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
import 'package:sakina_app/features/maladh/domain/services/prayer_location_catalog.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';

/// Modal bottom sheet allowing the user to select their country & city for 100% offline astronomical prayer times worldwide.
class PrayerLocationSelectorSheet extends StatefulWidget {
  final CityLocation currentCity;
  final ValueChanged<CityLocation>? onCitySelected;

  const PrayerLocationSelectorSheet({
    super.key,
    required this.currentCity,
    this.onCitySelected,
  });

  static Future<CityLocation?> show(
    BuildContext context, {
    required CityLocation currentCity,
    ValueChanged<CityLocation>? onCitySelected,
  }) {
    HapticService.lightImpact();
    return showModalBottomSheet<CityLocation>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PrayerLocationSelectorSheet(
        currentCity: currentCity,
        onCitySelected: onCitySelected,
      ),
    );
  }

  @override
  State<PrayerLocationSelectorSheet> createState() =>
      _PrayerLocationSelectorSheetState();
}

class _PrayerLocationSelectorSheetState
    extends State<PrayerLocationSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CityLocation> _filteredCities = PrayerLocationCatalog.allCities;
  late String _selectedCityId;
  bool _isDetectingGps = false;

  @override
  void initState() {
    super.initState();
    _selectedCityId = widget.currentCity.id;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCities =
          PrayerLocationCatalog.search(_searchController.text);
    });
  }

  Future<void> _handleCitySelection(CityLocation city) async {
    HapticService.selectionClick();
    setState(() => _selectedCityId = city.id);

    final prefs = sl.isRegistered<PreferencesService>()
        ? sl<PreferencesService>()
        : null;

    if (prefs != null) {
      await prefs.setString(
        PrayerLocationCatalog.keySelectedCityId,
        city.id,
      );

      // Re-schedule pre-prayer reminders for the new location's exact times
      if (sl.isRegistered<LocalNotificationService>()) {
        final notifService = sl<LocalNotificationService>();
        final enabled = prefs.getBool(
              SettingsPersistenceManager.keyPrePrayerReminder,
            ) ??
            true;
        unawaited(
          notifService.schedulePrePrayerReminders(
            enabled: enabled,
            prefs: prefs,
          ),
        );
      }
    }

    widget.onCitySelected?.call(city);

    if (mounted) {
      AppTopSnackBar.showSuccess(
        context: context,
        message: 'تم تحديد موقع المواقيت: ${city.displayName}',
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(city);
      }
    }
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
      await _handleCitySelection(resolvedCity);
    } else {
      AppTopSnackBar.show(
        context: context,
        message: 'تعذر جلب موقع GPS؛ يرجى التأكد من تشغيل الموقع أو اختيار المدينة يدوياً',
      );
    }
  }

  String _getMethodLabel(String method) {
    switch (method) {
      case 'umm_al_qura':
        return 'تقويم أم القرى';
      case 'dubai':
        return 'دائرة الشؤون الإسلامية بدبي';
      case 'kuwait':
        return 'وزارة الأوقاف الكويتية';
      case 'qatar':
        return 'وزارة الأوقاف القطرية';
      case 'karachi':
        return 'جامعة العلوم الإسلامية بكراتشي';
      case 'north_america':
        return 'الجمعية الإسلامية لأمريكا الشمالية';
      case 'singapore':
        return 'مجلس أوغاما سنغافورة';
      case 'turkey':
        return 'رئاسة الشؤون الدينية التركية';
      case 'muslim_world_league':
        return 'رابطة العالم الإسلامي';
      case 'egyptian':
      default:
        return 'الهيئة المصرية العامة للمساحة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafePadding = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 640.h,
        margin: EdgeInsets.only(bottom: keyboardInset),
        padding: EdgeInsets.only(bottom: bottomSafePadding + 14.h),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.6),
            width: 0.8.r,
          ),
        ),
        child: Column(
          children: [
            // Handle Bar
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderHairline.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // Sheet Title & Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.global,
                      color: colors.accentGold,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تَحْدِيدُ مَوْقِعِ المَوَاقِيتِ حَوْلَ العَالَم',
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'حِسَابٌ فَلَكِيٌّ دَقِيقٌ لِلصَّلَوَاتِ الخَمْسِ وَالتَّنْبِيهَاتِ بِدُونِ إِنْتَرْنِت',
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // 1. One-tap GPS Auto-Detect Button (Athkar Style)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InkWell(
                onTap: _isDetectingGps ? null : _handleGpsAutoDetect,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  height: 46.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: colors.accentGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.4),
                      width: 1.r,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isDetectingGps)
                        SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors.accentGold,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Iconsax.gps,
                          size: 18.r,
                          color: colors.accentGold,
                        ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          _isDetectingGps
                              ? 'جَارٍ تَحْدِيدُ مَوْقِعِكَ عَبْرَ الأَقْمَارِ الصِّنَاعِيَّةِ...'
                              : 'تَحْدِيدُ المَوْقِعِ تِلْقَائِيًّا عَبْرَ الأَقْمَارِ الصِّنَاعِيَّةِ (GPS)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: colors.background.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline.withValues(alpha: 0.5),
                    width: 0.8.r,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ابْحَثْ عَنِ الدَّوْلَةِ أَوِ المَدِينَةِ (صنعاء، مكة، القاهرة...)...',
                    hintStyle: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                    ),
                    prefixIcon: Icon(
                      Iconsax.search_normal_1,
                      size: 18.r,
                      color: colors.textSecondary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18.r,
                              color: colors.textSecondary,
                            ),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Cities List
            Expanded(
              child: _filteredCities.isEmpty
                  ? Center(
                      child: Text(
                        'لَا تُوجَدُ مَدِينَةٌ تُطَابِقُ بَحْثَكَ',
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredCities.length,
                      separatorBuilder: (context, index) => Divider(
                        color: colors.borderHairline.withValues(alpha: 0.3),
                        height: 1.h,
                      ),
                      itemBuilder: (context, index) {
                        final city = _filteredCities[index];
                        final isSelected = city.id == _selectedCityId;

                        return InkWell(
                          onTap: () => _handleCitySelection(city),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              children: [
                                // Radio checkmark icon
                                Container(
                                  width: 22.r,
                                  height: 22.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? colors.accentGold
                                          : colors.borderHairline,
                                      width: isSelected ? 2.r : 1.r,
                                    ),
                                    color: isSelected
                                        ? colors.accentGold.withValues(alpha: 0.15)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 10.r,
                                            height: 10.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colors.accentGold,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),

                                // City & Country info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            city.cityNameArabic,
                                            style: GoogleFonts.cairo(
                                              fontSize: 14.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? colors.accentGold
                                                  : colors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            '• ${city.countryNameArabic}',
                                            style: GoogleFonts.cairo(
                                              fontSize: 12.sp,
                                              color: colors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        _getMethodLabel(city.calculationMethod),
                                        style: GoogleFonts.cairo(
                                          fontSize: 10.sp,
                                          color: colors.textSecondary
                                              .withValues(alpha: 0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Timezone tag
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.background
                                        .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: colors.borderHairline
                                          .withValues(alpha: 0.4),
                                      width: 0.6.r,
                                    ),
                                  ),
                                  child: Text(
                                    'UTC${city.utcOffsetHours >= 0 ? '+' : ''}${city.utcOffsetHours.toInt()}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
