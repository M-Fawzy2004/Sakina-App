import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';

void main() {
  group('VerseCardItem Tests', () {
    test('single ayah has isRange=false and count=1', () {
      const item = VerseCardItem(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'الفاتحة',
        ayahText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        theme: 'أم الكتاب',
        durationSeconds: 5,
      );

      expect(item.isRange, isFalse);
      expect(item.versesCount, 1);
      expect(item.endAyahNumber, isNull);
    });

    test('ayah range has isRange=true and accurate count', () {
      const item = VerseCardItem(
        surahNumber: 2,
        ayahNumber: 1,
        endAyahNumber: 5,
        surahName: 'البقرة',
        ayahText: 'الم ۝ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ...',
        theme: 'هدى للمتقين',
        durationSeconds: 30,
      );

      expect(item.isRange, isTrue);
      expect(item.versesCount, 5);
      expect(item.endAyahNumber, 5);
    });

    test('copyWith updates fields while preserving others', () {
      const item = VerseCardItem(
        surahNumber: 112,
        ayahNumber: 1,
        surahName: 'الإخلاص',
        ayahText: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        theme: 'التوحيد',
        durationSeconds: 4,
      );

      final updated = item.copyWith(
        endAyahNumber: 4,
        ayahText: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ...',
        durationSeconds: 12,
      );

      expect(updated.surahNumber, 112);
      expect(updated.ayahNumber, 1);
      expect(updated.endAyahNumber, 4);
      expect(updated.isRange, isTrue);
      expect(updated.versesCount, 4);
      expect(updated.durationSeconds, 12);
    });

    test('getAyahTextAt returns individual text from versesTextList', () {
      const item = VerseCardItem(
        surahNumber: 114,
        ayahNumber: 1,
        endAyahNumber: 3,
        surahName: 'الناس',
        ayahText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        versesTextList: [
          'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
          'مَلِكِ النَّاسِ',
          'إِلَٰهِ النَّاسِ',
        ],
        theme: 'الاستعاذة',
        durationSeconds: 15,
      );

      expect(item.getAyahTextAt(0), 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ');
      expect(item.getAyahTextAt(1), 'مَلِكِ النَّاسِ');
      expect(item.getAyahTextAt(2), 'إِلَٰهِ النَّاسِ');
      expect(item.getAyahTextAt(99), 'إِلَٰهِ النَّاسِ');
    });

    test('findBestMatchingIndex selects optimal duration', () {
      final index = VerseCardItem.findBestMatchingIndex(11);
      expect(index, isNonNegative);
      expect(VerseCardItem.curatedVerses[index].durationSeconds, 11);
    });
  });
}

