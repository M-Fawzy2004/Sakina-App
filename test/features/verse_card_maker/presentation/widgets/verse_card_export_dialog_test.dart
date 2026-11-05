import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_export_dialog.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp(
        home: child,
      ),
    );
  }

  group('VerseCardExportDialog Tests', () {
    testWidgets('renders active progress percentage and CapCut warning banner',
        (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  VerseCardExportDialog.show(
                    context: context,
                    onShare: () {},
                    exportTask: (updateProgress) async {
                      updateProgress(0.45, 'جارٍ مونتاج الريلز ودمج الفيديو...');
                      await completer.future;
                    },
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('جَارٍ تَصْدِيرُ الرِّيلْز'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      expect(find.text('جارٍ مونتاج الريلز ودمج الفيديو...'), findsOneWidget);
      expect(
        find.textContaining('يُرْجَى إِبْقَاءُ الشَّاشَةِ نَشِطَةً وَعَدَمُ إِغْلَاقِ التَّطْبِيقِ'),
        findsOneWidget,
      );

      // Complete export task
      completer.complete();
      await tester.pumpAndSettle();

      expect(find.text('تَمَّ التَّصْدِيرُ بِنَجَاح'), findsOneWidget);
      expect(find.byIcon(Iconsax.tick_circle), findsOneWidget);
      expect(find.text('مُشَارَكَةُ الفِيدْيُو'), findsOneWidget);
      expect(find.text('تَمَّ الحِفْظُ فِي المَعْرِضِ'), findsOneWidget);
    });

    testWidgets('calls onShare when share button is tapped upon completion',
        (tester) async {
      bool shared = false;

      await tester.pumpWidget(
        buildTestableWidget(
          VerseCardExportDialog(
            onShare: () => shared = true,
            exportTask: (updateProgress) async {
              updateProgress(1.0, 'اكتمل!');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مُشَارَكَةُ الفِيدْيُو'), findsOneWidget);
      await tester.tap(find.text('مُشَارَكَةُ الفِيدْيُو'));
      await tester.pumpAndSettle();

      expect(shared, isTrue);
    });
  });
}
