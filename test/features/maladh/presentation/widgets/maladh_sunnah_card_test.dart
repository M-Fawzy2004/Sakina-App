import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_sunnah_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MaladhSunnahCard renders title, subtitle, badge and triggers onTap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: MaladhSunnahCard(
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('كُتُبُ السُّنَّةِ النَّبَوِيَّةِ'), findsOneWidget);
    expect(find.text('كتب الأصول'), findsOneWidget);
    expect(find.text('9 كُتُبٍ'), findsOneWidget);

    await tester.tap(find.byType(MaladhSunnahCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}

