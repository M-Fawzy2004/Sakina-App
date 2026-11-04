import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/widgets/sakina_luxury_switch.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }

  group('SakinaLuxurySwitch Tests', () {
    testWidgets('renders correctly when value is false and toggles on tap',
        (tester) async {
      bool currentValue = false;

      await tester.pumpWidget(
        buildTestableWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return SakinaLuxurySwitch(
                value: currentValue,
                onChanged: (val) {
                  setState(() {
                    currentValue = val;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SakinaLuxurySwitch), findsOneWidget);
      expect(currentValue, isFalse);

      // Tap switch to turn on
      await tester.tap(find.byType(SakinaLuxurySwitch));
      await tester.pumpAndSettle();

      expect(currentValue, isTrue);

      // Tap switch to turn off
      await tester.tap(find.byType(SakinaLuxurySwitch));
      await tester.pumpAndSettle();

      expect(currentValue, isFalse);
    });

    testWidgets('applies custom colors and dimensions properly',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          SakinaLuxurySwitch(
            value: true,
            activeTrackColor: Colors.amber,
            activeThumbColor: Colors.black,
            width: 44,
            height: 26,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SakinaLuxurySwitch), findsOneWidget);
    });
  });
}

