// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sakina';

  @override
  String get appTagline => 'Your Luxury Spiritual & Quranic Sanctuary';

  @override
  String get quran => 'Holy Quran';

  @override
  String get audio => 'Recitations';

  @override
  String get inaba => 'Inaba & Recovery';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Retry';

  @override
  String get networkError => 'No Internet Connection';

  @override
  String get serverError => 'Server error, please try again later';
}
