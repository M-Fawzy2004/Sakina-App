import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_tafsir_reflection_sheet.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  const testSurah = SurahEntity(
    id: 2,
    nameArabic: 'البَقَرَة',
    englishName: 'Al-Baqarah',
    revelationType: 'مدنية',
    versesCount: 286,
    pageNumber: 2,
    juzNumber: 1,
  );

  const testAyah = AyahEntity(
    numberInSurah: 26,
    text: 'إِنَّ اللَّهَ لَا يَسْتَحْيِي أَن يَضْرِبَ مَثَلًا مَّا بَعُوضَةً',
    page: 2,
    juz: 1,
    reflection: 'تدبر هذه الآية يورث اليقين بحكمة ضرب الأمثال.',
    tafsirs: [
      TafsirEntity(
        type: 'التفسير المختصر',
        text: 'إن الله سبحانه وتعالى لا يستحي من ضرب الأمثال بما شاء...',
      ),
      TafsirEntity(
        type: 'تفسير الجلالين',
        text: '«إن الله لا يستحي» لا يترك لخشية...',
      ),
      TafsirEntity(
        type: 'تفسير السعدي',
        text: 'يخبر تعالى أنه لا يستحيي من الحق وبيانه...',
      ),
    ],
  );

  group('QuranTafsirReflectionSheet Widget Tests', () {
    testWidgets('renders clean Tafsir without record or large verse box, and switches tafsirs', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          QuranTafsirReflectionSheet(
            surah: testSurah,
            ayah: testAyah,
            onClose: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Audio Recorder and Play controls are NOT present
      expect(find.byIcon(Iconsax.pause), findsNothing);
      expect(find.byIcon(Iconsax.play), findsNothing);

      // 2. Verify Large highlighted verse box is NOT present in sheet
      expect(find.text('«إِنَّ اللَّهَ لَا يَسْتَحْيِي أَن يَضْرِبَ مَثَلًا مَّا بَعُوضَةً»'), findsNothing);

      // 3. Verify Header information
      expect(find.text('سُورَةُ البَقَرَة'), findsOneWidget);
      expect(find.text('26'), findsOneWidget);

      // 4. Verify initial Tafsir (التفسير المختصر)
      expect(find.text('إن الله سبحانه وتعالى لا يستحي من ضرب الأمثال بما شاء...'), findsOneWidget);

      // 5. Verify Tafsir category chips are displayed
      expect(find.text('التفسير المختصر'), findsNWidgets(2)); // Chip and Body card title
      expect(find.text('تفسير الجلالين'), findsOneWidget);
      expect(find.text('تفسير السعدي'), findsOneWidget);

      // 6. Tap on "تفسير السعدي" chip and verify instant local switch
      await tester.ensureVisible(find.text('تفسير السعدي'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('تفسير السعدي'));
      await tester.pumpAndSettle();

      expect(find.text('يخبر تعالى أنه لا يستحيي من الحق وبيانه...'), findsOneWidget);

      // 7. Verify spiritual reflection is displayed
      expect(find.text('تدبر هذه الآية يورث اليقين بحكمة ضرب الأمثال.'), findsOneWidget);

      // 8. Verify action buttons
      expect(find.text('نَسْخ'), findsOneWidget);
      expect(find.text('مُشَارَكَة'), findsOneWidget);
    });
  });
}
