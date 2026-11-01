import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_continue_quran_card.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.charcoalLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  group('MaladhContinueQuranCard Widget Tests', () {
    testWidgets('renders custom initialBookmark with accurate Surah, Ayah, Page, and percentage', (tester) async {
      final testBookmark = QuranBookmarkEntity(
        surahId: 2,
        surahName: 'سُورَةُ البَقَرَةِ',
        ayahNumber: 45,
        pageNumber: 7,
        timestamp: DateTime(2026, 11, 1),
      );

      await tester.pumpWidget(
        createTestWidget(
          MaladhContinueQuranCard(
            initialBookmark: testBookmark,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header Tag and Percentage Badge (45/286 ~= 16%)
      expect(find.text('وَاصِلْ وِرْدَكَ القُرْآنِيّ'), findsOneWidget);
      expect(find.text('16%'), findsOneWidget);

      // Verify Surah Name
      expect(find.text('سُورَةُ البَقَرَةِ'), findsOneWidget);

      // Verify Ayah and Page Subtitle
      expect(find.text('الآية 45 من 286 • صفحة 7'), findsOneWidget);

      // Verify Action Row and CTA
      expect(find.text('آخِرُ مَوْضِعٍ تَمَّتْ قِرَاءَتُهُ'), findsOneWidget);
      expect(find.text('مُوَاصَلَةُ القِرَاءَةِ'), findsOneWidget);

      // Verify that the old bottom reciter box is completely removed
      expect(find.textContaining('المنشاوي'), findsNothing);
      expect(find.text('استئناف'), findsNothing);
    });

    testWidgets('triggers onResumeTap callback when tapped', (tester) async {
      bool tapped = false;
      final testBookmark = QuranBookmarkEntity(
        surahId: 55,
        surahName: 'سُورَةُ الرَّحْمَن',
        ayahNumber: 27,
        pageNumber: 532,
        timestamp: DateTime(2026, 11, 1),
      );

      await tester.pumpWidget(
        createTestWidget(
          MaladhContinueQuranCard(
            initialBookmark: testBookmark,
            onResumeTap: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MaladhContinueQuranCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
      expect(find.text('سُورَةُ الرَّحْمَن'), findsOneWidget);
      expect(find.text('الآية 27 من 78 • صفحة 532'), findsOneWidget);
      // 27 / 78 = ~35%
      expect(find.text('35%'), findsOneWidget);
    });
  });
}

