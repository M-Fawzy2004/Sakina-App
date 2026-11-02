import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_hisn_muslim_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MaladhHisnMuslimCard renders title, subtitle, badge and responds to tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          theme: AppTheme.charcoalLuxury,
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: MaladhHisnMuslimCard(
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

    expect(find.text('حِصْنُ المُسْلِمِ'), findsOneWidget);
    expect(find.text('جامع الأوراد'), findsOneWidget);
    expect(find.text('132 باباً'), findsOneWidget);

    await tester.tap(find.byType(MaladhHisnMuslimCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
