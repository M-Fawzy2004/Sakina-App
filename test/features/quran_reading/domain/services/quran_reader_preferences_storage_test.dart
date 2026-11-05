import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/domain/services/quran_reader_preferences_storage.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
  });

  group('QuranReaderPreferencesStorage', () {
    test('load returns factory defaults when nothing is saved in storage', () {
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getDouble(any())).thenReturn(null);

      final prefs = QuranReaderPreferencesStorage.load(mockPrefs);

      expect(prefs.style, QuranReadingStyle.continuous);
      expect(prefs.scriptStyle, QuranScriptStyle.uthmani);
      expect(prefs.fontSize, QuranFontSize.medium);
      expect(prefs.theme, QuranReaderTheme.charcoal);
      expect(prefs.lineSpacing, QuranLineSpacing.relaxed);
      expect(prefs.showDividers, true);
      expect(prefs.autoScrollSpeed, 1.0);
      expect(prefs.isKeepScreenAwake, true);
    });

    test('load correctly restores saved custom values from storage', () {
      when(() => mockPrefs.getString(QuranReaderPreferencesStorage.keyStyle))
          .thenReturn('verseByVerse');
      when(() => mockPrefs.getString(QuranReaderPreferencesStorage.keyScriptStyle))
          .thenReturn('amiri');
      when(() => mockPrefs.getString(QuranReaderPreferencesStorage.keyFontSize))
          .thenReturn('large');
      when(() => mockPrefs.getString(QuranReaderPreferencesStorage.keyTheme))
          .thenReturn('emerald');
      when(() => mockPrefs.getString(QuranReaderPreferencesStorage.keyLineSpacing))
          .thenReturn('spacious');
      when(() => mockPrefs.getBool(QuranReaderPreferencesStorage.keyShowDividers))
          .thenReturn(false);
      when(() => mockPrefs.getDouble(QuranReaderPreferencesStorage.keyAutoScrollSpeed))
          .thenReturn(1.5);
      when(() => mockPrefs.getBool(QuranReaderPreferencesStorage.keyKeepAwake))
          .thenReturn(false);

      final prefs = QuranReaderPreferencesStorage.load(mockPrefs);

      expect(prefs.style, QuranReadingStyle.verseByVerse);
      expect(prefs.scriptStyle, QuranScriptStyle.amiri);
      expect(prefs.fontSize, QuranFontSize.large);
      expect(prefs.theme, QuranReaderTheme.emerald);
      expect(prefs.lineSpacing, QuranLineSpacing.spacious);
      expect(prefs.showDividers, false);
      expect(prefs.autoScrollSpeed, 1.5);
      expect(prefs.isKeepScreenAwake, false);
    });

    test('save writes all properties to PreferencesService', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setDouble(any(), any())).thenAnswer((_) async => true);

      const customPrefs = QuranReaderPreferences(
        style: QuranReadingStyle.verseByVerse,
        scriptStyle: QuranScriptStyle.amiri,
        fontSize: QuranFontSize.extraLarge,
        theme: QuranReaderTheme.emerald,
        lineSpacing: QuranLineSpacing.normal,
        showDividers: false,
        autoScrollSpeed: 2.0,
        isKeepScreenAwake: false,
      );

      await QuranReaderPreferencesStorage.save(mockPrefs, customPrefs);

      verify(() => mockPrefs.setString(QuranReaderPreferencesStorage.keyStyle, 'verseByVerse')).called(1);
      verify(() => mockPrefs.setString(QuranReaderPreferencesStorage.keyScriptStyle, 'amiri')).called(1);
      verify(() => mockPrefs.setString(QuranReaderPreferencesStorage.keyFontSize, 'extraLarge')).called(1);
      verify(() => mockPrefs.setString(QuranReaderPreferencesStorage.keyTheme, 'emerald')).called(1);
      verify(() => mockPrefs.setString(QuranReaderPreferencesStorage.keyLineSpacing, 'normal')).called(1);
      verify(() => mockPrefs.setBool(QuranReaderPreferencesStorage.keyShowDividers, false)).called(1);
      verify(() => mockPrefs.setDouble(QuranReaderPreferencesStorage.keyAutoScrollSpeed, 2.0)).called(1);
      verify(() => mockPrefs.setBool(QuranReaderPreferencesStorage.keyKeepAwake, false)).called(1);
    });

    test('reset clears all keys from PreferencesService', () async {
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      await QuranReaderPreferencesStorage.reset(mockPrefs);

      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyStyle)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyScriptStyle)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyFontSize)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyTheme)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyLineSpacing)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyShowDividers)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyAutoScrollSpeed)).called(1);
      verify(() => mockPrefs.remove(QuranReaderPreferencesStorage.keyKeepAwake)).called(1);
    });
  });
}
