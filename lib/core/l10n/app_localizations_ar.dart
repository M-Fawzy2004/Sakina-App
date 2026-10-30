// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سكينة';

  @override
  String get appTagline => 'ملاذك الروحي والقرآني الفاخر';

  @override
  String get quran => 'القرآن الكريم';

  @override
  String get audio => 'التلاوات العطرة';

  @override
  String get inaba => 'إنابة والتعافي';

  @override
  String get bookmarks => 'الفواصل والختمات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get networkError => 'لا يوجد اتصال بالإنترنت';

  @override
  String get serverError => 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';
}
