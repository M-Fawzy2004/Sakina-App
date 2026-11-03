import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_hope_background_selector.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_hope_card_view.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.darkLuxury,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  group('Inaba Hope Customization Widget Tests', () {
    const testDose = DailyHopeDoseEntity(
      id: 'test_dose_1',
      quotation: '«إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ»',
      source: 'سورة البقرة • آية 222',
      explanation: 'محبة الله لا تنال بالمعصومية من الخطأ بل بالمسارعة إلى التوبة',
      isSaved: false,
    );

    testWidgets('InabaHopeCardView renders quotation, source, explanation and watermark',
        (tester) async {
      final cardKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          InabaHopeCardView(
            cardKey: cardKey,
            activeDose: testDose,
            selectedBackground: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(testDose.quotation), findsOneWidget);
      expect(find.text(testDose.source), findsOneWidget);
      expect(find.text(testDose.explanation), findsOneWidget);
      expect(find.text('تطبيق سَكِينَة 🌿'), findsOneWidget);
    });

    testWidgets('InabaHopeBackgroundSelector renders background options and invokes onSelect',
        (tester) async {
      String? selectedAsset = InabaHopeBackgroundSelector.backgroundAssets.first;
      String? updatedAsset;

      await tester.pumpWidget(
        createTestWidget(
          InabaHopeBackgroundSelector(
            selectedAsset: selectedAsset,
            onSelect: (val) => updatedAsset = val,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('خلفية البطاقة:'), findsOneWidget);

      // Tap on the default theme option (brush icon)
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);

      await tester.tap(inkWells.first);
      await tester.pumpAndSettle();

      expect(updatedAsset, isNull);
    });
  });
}

