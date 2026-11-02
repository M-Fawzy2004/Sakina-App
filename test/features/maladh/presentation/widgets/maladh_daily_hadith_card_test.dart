import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/domain/entities/daily_hadith_item.dart';
import 'package:sakina_app/features/maladh/domain/services/daily_hadith_service.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_daily_hadith_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testHadith = DailyHadithItem(
    id: 1,
    arabic: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
    bookKey: 'bukhari',
    bookTitleAr: 'صحيح البخاري',
    narratorAr: 'عن عمر بن الخطاب رضي الله عنه',
    hadithNumber: 1,
    chapterId: 1,
    topic: 'إخلاص النية',
  );

  group('DailyHadithService Tests', () {
    test('getTodayHadith returns a valid hadith deterministically', () {
      final hadith1 = DailyHadithService.getTodayHadith(DateTime(2026, 11, 2));
      final hadith2 = DailyHadithService.getTodayHadith(DateTime(2026, 11, 2));

      expect(hadith1.id, hadith2.id);
      expect(hadith1.arabic.isNotEmpty, isTrue);
      expect(hadith1.bookTitleAr.isNotEmpty, isTrue);
      expect(hadith1.narratorAr.isNotEmpty, isTrue);
    });

    test('getHadithById returns correct hadith', () {
      final hadith = DailyHadithService.getHadithById(5);
      expect(hadith.id, 5);
      expect(hadith.topic, 'فضل التسبيح');
    });
  });

  group('MaladhDailyHadithCard Widget Tests', () {
    testWidgets(
        'renders daily hadith card with prophetic title, text, narrator, and topic badge',
        (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.charcoalLuxury,
            home: const Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: MaladhDailyHadithCard(customHadith: testHadith),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('حَدِيثُ اليَوْم'), findsOneWidget);
      expect(find.text('إخلاص النية'), findsOneWidget);
      expect(find.text('صحيح البخاري'), findsOneWidget);
      expect(
          find.text('«إنما الأعمال بالنيات وإنما لكل امرئ ما نوى»'),
          findsOneWidget);
      expect(find.text('عن عمر بن الخطاب رضي الله عنه'), findsOneWidget);
      expect(find.text('قراءة كاملة'), findsOneWidget);
    });

    testWidgets('tapping card opens detail bottom sheet with full text',
        (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.charcoalLuxury,
            home: const Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: MaladhDailyHadithCard(customHadith: testHadith),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('قراءة كاملة'));
      await tester.pumpAndSettle();

      expect(find.text('حَدِيثُ اليَوْمِ الشَّرِيف'), findsOneWidget);
      expect(find.text('نسخ الحديث الشريف'), findsOneWidget);
    });
  });
}
