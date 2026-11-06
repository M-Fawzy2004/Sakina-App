import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/city_location.dart';

/// Pre-seeded offline catalog of worldwide countries and major cities with coordinates and prayer calculation methods.
abstract final class PrayerLocationCatalog {
  static const String keySelectedCityId = 'sakina_prayer_selected_city_id';

  static const CityLocation defaultLocation = CityLocation(
    id: 'eg_cairo',
    cityNameArabic: 'القاهرة',
    countryNameArabic: 'مصر',
    countryCode: 'EG',
    latitude: 30.0444,
    longitude: 31.2357,
    utcOffsetHours: 2.0,
    calculationMethod: 'egyptian',
  );

  static const List<CityLocation> allCities = [
    // 1. اليمن (Yemen)
    CityLocation(
      id: 'ye_sanaa',
      cityNameArabic: 'صنعاء',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 15.3694,
      longitude: 44.1910,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_aden',
      cityNameArabic: 'عدن',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 12.7855,
      longitude: 45.0187,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_taiz',
      cityNameArabic: 'تعز',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 13.5795,
      longitude: 44.0209,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_hodeidah',
      cityNameArabic: 'الحديدة',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 14.7978,
      longitude: 42.9545,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_ibb',
      cityNameArabic: 'إب',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 13.9667,
      longitude: 44.1667,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_mukalla',
      cityNameArabic: 'المكلا',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 14.5425,
      longitude: 49.1242,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ye_dhamar',
      cityNameArabic: 'ذمار',
      countryNameArabic: 'اليمن',
      countryCode: 'YE',
      latitude: 14.5428,
      longitude: 44.4051,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 2. مصر (Egypt)
    defaultLocation,
    CityLocation(
      id: 'eg_alexandria',
      cityNameArabic: 'الإسكندرية',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 31.2001,
      longitude: 29.9187,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_giza',
      cityNameArabic: 'الجيزة',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 30.0131,
      longitude: 31.2089,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_mansoura',
      cityNameArabic: 'المنصورة',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 31.0409,
      longitude: 31.3785,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_tanta',
      cityNameArabic: 'طنطا',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 30.7865,
      longitude: 31.0004,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_aswan',
      cityNameArabic: 'أسوان',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 24.0889,
      longitude: 32.8998,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_luxor',
      cityNameArabic: 'الأقصر',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 25.6872,
      longitude: 32.6396,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_port_said',
      cityNameArabic: 'بورسعيد',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 31.2653,
      longitude: 32.3019,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_suez',
      cityNameArabic: 'السويس',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 29.9668,
      longitude: 32.5498,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_ismailia',
      cityNameArabic: 'الإسماعيلية',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 30.5965,
      longitude: 32.2715,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),
    CityLocation(
      id: 'eg_asyut',
      cityNameArabic: 'أسيوط',
      countryNameArabic: 'مصر',
      countryCode: 'EG',
      latitude: 27.1783,
      longitude: 31.1859,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),

    // 3. المملكة العربية السعودية (Saudi Arabia)
    CityLocation(
      id: 'sa_makkah',
      cityNameArabic: 'مكة المكرمة',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 21.3891,
      longitude: 39.8579,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_madinah',
      cityNameArabic: 'المدينة المنورة',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 24.5247,
      longitude: 39.5692,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_riyadh',
      cityNameArabic: 'الرياض',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 24.7136,
      longitude: 46.6753,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_jeddah',
      cityNameArabic: 'جدة',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 21.5433,
      longitude: 39.1728,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_dammam',
      cityNameArabic: 'الدمام',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 26.4207,
      longitude: 50.0888,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_taif',
      cityNameArabic: 'الطائف',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 21.2854,
      longitude: 40.4222,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_tabuk',
      cityNameArabic: 'تبوك',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 28.3835,
      longitude: 36.5662,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_abha',
      cityNameArabic: 'أبها',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 18.2164,
      longitude: 42.5053,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'sa_buraidah',
      cityNameArabic: 'بريدة',
      countryNameArabic: 'السعودية',
      countryCode: 'SA',
      latitude: 26.3260,
      longitude: 43.9750,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 4. الإمارات العربية المتحدة (UAE)
    CityLocation(
      id: 'ae_dubai',
      cityNameArabic: 'دبي',
      countryNameArabic: 'الإمارات',
      countryCode: 'AE',
      latitude: 25.2048,
      longitude: 55.2708,
      utcOffsetHours: 4.0,
      calculationMethod: 'dubai',
    ),
    CityLocation(
      id: 'ae_abu_dhabi',
      cityNameArabic: 'أبوظبي',
      countryNameArabic: 'الإمارات',
      countryCode: 'AE',
      latitude: 24.4539,
      longitude: 54.3773,
      utcOffsetHours: 4.0,
      calculationMethod: 'dubai',
    ),
    CityLocation(
      id: 'ae_sharjah',
      cityNameArabic: 'الشارقة',
      countryNameArabic: 'الإمارات',
      countryCode: 'AE',
      latitude: 25.3463,
      longitude: 55.4209,
      utcOffsetHours: 4.0,
      calculationMethod: 'dubai',
    ),
    CityLocation(
      id: 'ae_al_ain',
      cityNameArabic: 'العين',
      countryNameArabic: 'الإمارات',
      countryCode: 'AE',
      latitude: 24.2075,
      longitude: 55.7447,
      utcOffsetHours: 4.0,
      calculationMethod: 'dubai',
    ),

    // 5. الكويت (Kuwait)
    CityLocation(
      id: 'kw_kuwait',
      cityNameArabic: 'مدينة الكويت',
      countryNameArabic: 'الكويت',
      countryCode: 'KW',
      latitude: 29.3759,
      longitude: 47.9774,
      utcOffsetHours: 3.0,
      calculationMethod: 'kuwait',
    ),

    // 6. قطر (Qatar)
    CityLocation(
      id: 'qa_doha',
      cityNameArabic: 'الدوحة',
      countryNameArabic: 'قطر',
      countryCode: 'QA',
      latitude: 25.2854,
      longitude: 51.5310,
      utcOffsetHours: 3.0,
      calculationMethod: 'qatar',
    ),

    // 7. سلطنة عُمان (Oman)
    CityLocation(
      id: 'om_muscat',
      cityNameArabic: 'مسقط',
      countryNameArabic: 'عُمان',
      countryCode: 'OM',
      latitude: 23.5880,
      longitude: 58.3829,
      utcOffsetHours: 4.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'om_salalah',
      cityNameArabic: 'صلالة',
      countryNameArabic: 'عُمان',
      countryCode: 'OM',
      latitude: 17.0151,
      longitude: 54.0924,
      utcOffsetHours: 4.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 8. البحرين (Bahrain)
    CityLocation(
      id: 'bh_manama',
      cityNameArabic: 'المنامة',
      countryNameArabic: 'البحرين',
      countryCode: 'BH',
      latitude: 26.2285,
      longitude: 50.5860,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 9. الأردن (Jordan)
    CityLocation(
      id: 'jo_amman',
      cityNameArabic: 'عمّان',
      countryNameArabic: 'الأردن',
      countryCode: 'JO',
      latitude: 31.9454,
      longitude: 35.9284,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'jo_irbid',
      cityNameArabic: 'إربد',
      countryNameArabic: 'الأردن',
      countryCode: 'JO',
      latitude: 32.5568,
      longitude: 35.8469,
      utcOffsetHours: 3.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 10. فلسطين (Palestine)
    CityLocation(
      id: 'ps_jerusalem',
      cityNameArabic: 'القدس الشريف',
      countryNameArabic: 'فلسطين',
      countryCode: 'PS',
      latitude: 31.7683,
      longitude: 35.2137,
      utcOffsetHours: 2.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ps_gaza',
      cityNameArabic: 'غزة',
      countryNameArabic: 'فلسطين',
      countryCode: 'PS',
      latitude: 31.5017,
      longitude: 34.4668,
      utcOffsetHours: 2.0,
      calculationMethod: 'umm_al_qura',
    ),
    CityLocation(
      id: 'ps_hebron',
      cityNameArabic: 'الخليل',
      countryNameArabic: 'فلسطين',
      countryCode: 'PS',
      latitude: 31.5326,
      longitude: 35.0998,
      utcOffsetHours: 2.0,
      calculationMethod: 'umm_al_qura',
    ),

    // 11. العراق (Iraq)
    CityLocation(
      id: 'iq_baghdad',
      cityNameArabic: 'بغداد',
      countryNameArabic: 'العراق',
      countryCode: 'IQ',
      latitude: 33.3152,
      longitude: 44.3661,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'iq_basra',
      cityNameArabic: 'البصرة',
      countryNameArabic: 'العراق',
      countryCode: 'IQ',
      latitude: 30.5081,
      longitude: 47.7835,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'iq_erbil',
      cityNameArabic: 'أربيل',
      countryNameArabic: 'العراق',
      countryCode: 'IQ',
      latitude: 36.1911,
      longitude: 44.0091,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 12. سوريا (Syria)
    CityLocation(
      id: 'sy_damascus',
      cityNameArabic: 'دمشق',
      countryNameArabic: 'سوريا',
      countryCode: 'SY',
      latitude: 33.5138,
      longitude: 36.2765,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'sy_aleppo',
      cityNameArabic: 'حلب',
      countryNameArabic: 'سوريا',
      countryCode: 'SY',
      latitude: 36.2021,
      longitude: 37.1343,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 13. لبنان (Lebanon)
    CityLocation(
      id: 'lb_beirut',
      cityNameArabic: 'بيروت',
      countryNameArabic: 'لبنان',
      countryCode: 'LB',
      latitude: 33.8938,
      longitude: 35.5018,
      utcOffsetHours: 2.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 14. السودان (Sudan)
    CityLocation(
      id: 'sd_khartoum',
      cityNameArabic: 'الخرطوم',
      countryNameArabic: 'السودان',
      countryCode: 'SD',
      latitude: 15.5007,
      longitude: 32.5599,
      utcOffsetHours: 2.0,
      calculationMethod: 'egyptian',
    ),

    // 15. ليبيا (Libya)
    CityLocation(
      id: 'ly_tripoli',
      cityNameArabic: 'طرابلس',
      countryNameArabic: 'ليبيا',
      countryCode: 'LY',
      latitude: 32.8872,
      longitude: 13.1913,
      utcOffsetHours: 2.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'ly_benghazi',
      cityNameArabic: 'بنغازي',
      countryNameArabic: 'ليبيا',
      countryCode: 'LY',
      latitude: 32.1167,
      longitude: 20.0667,
      utcOffsetHours: 2.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 16. تونس (Tunisia)
    CityLocation(
      id: 'tn_tunis',
      cityNameArabic: 'تونس',
      countryNameArabic: 'تونس',
      countryCode: 'TN',
      latitude: 36.8065,
      longitude: 10.1815,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 17. الجزائر (Algeria)
    CityLocation(
      id: 'dz_algiers',
      cityNameArabic: 'الجزائر',
      countryNameArabic: 'الجزائر',
      countryCode: 'DZ',
      latitude: 36.7538,
      longitude: 3.0588,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'dz_oran',
      cityNameArabic: 'وهران',
      countryNameArabic: 'الجزائر',
      countryCode: 'DZ',
      latitude: 35.6971,
      longitude: -0.6308,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 18. المغرب (Morocco)
    CityLocation(
      id: 'ma_rabat',
      cityNameArabic: 'الرباط',
      countryNameArabic: 'المغرب',
      countryCode: 'MA',
      latitude: 34.0209,
      longitude: -6.8416,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'ma_casablanca',
      cityNameArabic: 'الدار البيضاء',
      countryNameArabic: 'المغرب',
      countryCode: 'MA',
      latitude: 33.5731,
      longitude: -7.5898,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),
    CityLocation(
      id: 'ma_marrakech',
      cityNameArabic: 'مراكش',
      countryNameArabic: 'المغرب',
      countryCode: 'MA',
      latitude: 31.6295,
      longitude: -7.9811,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 19. موريتانيا (Mauritania)
    CityLocation(
      id: 'mr_nouakchott',
      cityNameArabic: 'نواكشوط',
      countryNameArabic: 'موريتانيا',
      countryCode: 'MR',
      latitude: 18.0735,
      longitude: -15.9582,
      utcOffsetHours: 0.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 20. الصومال (Somalia)
    CityLocation(
      id: 'so_mogadishu',
      cityNameArabic: 'مقديشو',
      countryNameArabic: 'الصومال',
      countryCode: 'SO',
      latitude: 2.0469,
      longitude: 45.3182,
      utcOffsetHours: 3.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 21. تركيا (Turkey)
    CityLocation(
      id: 'tr_istanbul',
      cityNameArabic: 'إسطنبول',
      countryNameArabic: 'تركيا',
      countryCode: 'TR',
      latitude: 41.0082,
      longitude: 28.9784,
      utcOffsetHours: 3.0,
      calculationMethod: 'turkey',
    ),
    CityLocation(
      id: 'tr_ankara',
      cityNameArabic: 'أنقرة',
      countryNameArabic: 'تركيا',
      countryCode: 'TR',
      latitude: 39.9334,
      longitude: 32.8597,
      utcOffsetHours: 3.0,
      calculationMethod: 'turkey',
    ),

    // 22. إندونيسيا (Indonesia)
    CityLocation(
      id: 'id_jakarta',
      cityNameArabic: 'جاكرتا',
      countryNameArabic: 'إندونيسيا',
      countryCode: 'ID',
      latitude: -6.2088,
      longitude: 106.8456,
      utcOffsetHours: 7.0,
      calculationMethod: 'singapore',
    ),

    // 23. ماليزيا (Malaysia)
    CityLocation(
      id: 'my_kuala_lumpur',
      cityNameArabic: 'كوالالمبور',
      countryNameArabic: 'ماليزيا',
      countryCode: 'MY',
      latitude: 3.1390,
      longitude: 101.6869,
      utcOffsetHours: 8.0,
      calculationMethod: 'singapore',
    ),

    // 24. باكستان (Pakistan)
    CityLocation(
      id: 'pk_islamabad',
      cityNameArabic: 'إسلام آباد',
      countryNameArabic: 'باكستان',
      countryCode: 'PK',
      latitude: 33.6844,
      longitude: 73.0479,
      utcOffsetHours: 5.0,
      calculationMethod: 'karachi',
    ),
    CityLocation(
      id: 'pk_karachi',
      cityNameArabic: 'كراتشي',
      countryNameArabic: 'باكستان',
      countryCode: 'PK',
      latitude: 24.8607,
      longitude: 67.0011,
      utcOffsetHours: 5.0,
      calculationMethod: 'karachi',
    ),

    // 25. المملكة المتحدة (UK)
    CityLocation(
      id: 'gb_london',
      cityNameArabic: 'لندن',
      countryNameArabic: 'بريطانيا',
      countryCode: 'GB',
      latitude: 51.5074,
      longitude: -0.1278,
      utcOffsetHours: 0.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 26. الولايات المتحدة (USA)
    CityLocation(
      id: 'us_new_york',
      cityNameArabic: 'نيويورك',
      countryNameArabic: 'أمريكا',
      countryCode: 'US',
      latitude: 40.7128,
      longitude: -74.0060,
      utcOffsetHours: -5.0,
      calculationMethod: 'north_america',
    ),
    CityLocation(
      id: 'us_los_angeles',
      cityNameArabic: 'لوس أنجلوس',
      countryNameArabic: 'أمريكا',
      countryCode: 'US',
      latitude: 34.0522,
      longitude: -118.2437,
      utcOffsetHours: -8.0,
      calculationMethod: 'north_america',
    ),

    // 27. فرنسا (France)
    CityLocation(
      id: 'fr_paris',
      cityNameArabic: 'باريس',
      countryNameArabic: 'فرنسا',
      countryCode: 'FR',
      latitude: 48.8566,
      longitude: 2.3522,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 28. ألمانيا (Germany)
    CityLocation(
      id: 'de_berlin',
      cityNameArabic: 'برلين',
      countryNameArabic: 'ألمانيا',
      countryCode: 'DE',
      latitude: 52.5200,
      longitude: 13.4050,
      utcOffsetHours: 1.0,
      calculationMethod: 'muslim_world_league',
    ),

    // 29. كندا (Canada)
    CityLocation(
      id: 'ca_toronto',
      cityNameArabic: 'تورونتو',
      countryNameArabic: 'كندا',
      countryCode: 'CA',
      latitude: 43.6532,
      longitude: -79.3832,
      utcOffsetHours: -5.0,
      calculationMethod: 'north_america',
    ),

    // 30. أستراليا (Australia)
    CityLocation(
      id: 'au_sydney',
      cityNameArabic: 'سيدني',
      countryNameArabic: 'أستراليا',
      countryCode: 'AU',
      latitude: -33.8688,
      longitude: 151.2093,
      utcOffsetHours: 11.0,
      calculationMethod: 'muslim_world_league',
    ),
  ];

  /// Finds a city location by its unique id.
  static CityLocation findById(String id) {
    for (final city in allCities) {
      if (city.id == id) return city;
    }
    return defaultLocation;
  }

  /// Finds the currently active user location from stored preferences.
  static CityLocation findFromPreferences(PreferencesService? prefs) {
    if (prefs == null) return defaultLocation;
    final savedId = prefs.getString(keySelectedCityId);
    if (savedId == null || savedId.isEmpty) {
      return detectInitialLocation();
    }
    return findById(savedId);
  }

  /// Automatically selects an initial smart default city based on device timezone offset.
  static CityLocation detectInitialLocation() {
    final offsetHours = DateTime.now().timeZoneOffset.inHours;
    if (offsetHours == 3) {
      // Yemen / Saudi Arabia timezone
      return findById('ye_sanaa');
    } else if (offsetHours == 4) {
      // UAE / Oman timezone
      return findById('ae_dubai');
    } else if (offsetHours == 1) {
      // Morocco / Tunisia / Algeria / Europe
      return findById('ma_casablanca');
    } else if (offsetHours == 0) {
      // UK / Mauritania
      return findById('gb_london');
    }
    return defaultLocation; // Egypt default (+2)
  }

  /// Finds the closest city in the catalog to the given GPS coordinates.
  static CityLocation findClosest(double latitude, double longitude) {
    CityLocation closest = defaultLocation;
    double minDistanceSquared = double.infinity;

    for (final city in allCities) {
      final dLat = city.latitude - latitude;
      final dLng = city.longitude - longitude;
      final distSq = (dLat * dLat) + (dLng * dLng);
      if (distSq < minDistanceSquared) {
        minDistanceSquared = distSq;
        closest = city;
      }
    }

    return closest;
  }

  /// Constructs a localized [CityLocation] from GPS coordinates, associating the closest city & country metadata.
  static CityLocation fromGps({
    required double latitude,
    required double longitude,
  }) {
    final matchedCity = findClosest(latitude, longitude);
    return CityLocation(
      id: matchedCity.id,
      cityNameArabic: matchedCity.cityNameArabic,
      countryNameArabic: matchedCity.countryNameArabic,
      countryCode: matchedCity.countryCode,
      latitude: latitude,
      longitude: longitude,
      utcOffsetHours: matchedCity.utcOffsetHours,
      calculationMethod: matchedCity.calculationMethod,
    );
  }

  /// Filters cities by search query across city and country names.
  static List<CityLocation> search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return allCities;

    return allCities.where((c) {
      return c.cityNameArabic.toLowerCase().contains(cleanQuery) ||
          c.countryNameArabic.toLowerCase().contains(cleanQuery) ||
          c.id.toLowerCase().contains(cleanQuery);
    }).toList();
  }
}

