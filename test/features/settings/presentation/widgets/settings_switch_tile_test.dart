import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/widgets/sakina_luxury_switch.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_switch_tile.dart';

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

  group('SettingsSwitchTile Tests', () {
    testWidgets('renders title, subtitle, icon, and switch', (tester) async {
      bool toggleValue = false;

      await tester.pumpWidget(
        buildTestableWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return SettingsSwitchTile(
                icon: Iconsax.notification,
                title: 'تنبيهات أذكار الصباح والمساء',
                subtitle: 'تذكير يومي منتظم لحفظ الأوقات',
                value: toggleValue,
                onChanged: (val) {
                  setState(() {
                    toggleValue = val;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تنبيهات أذكار الصباح والمساء'), findsOneWidget);
      expect(find.text('تذكير يومي منتظم لحفظ الأوقات'), findsOneWidget);
      expect(find.byType(SakinaLuxurySwitch), findsOneWidget);

      // Tapping anywhere on the tile should toggle value
      await tester.tap(find.text('تنبيهات أذكار الصباح والمساء'));
      await tester.pumpAndSettle();

      expect(toggleValue, isTrue);

      // Tapping the switch itself toggles back
      await tester.tap(find.byType(SakinaLuxurySwitch));
      await tester.pumpAndSettle();

      expect(toggleValue, isFalse);
    });
  });
}

