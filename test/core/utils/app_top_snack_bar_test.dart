import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';

void main() {
  Widget buildTestApp({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.darkLuxury,
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('AppTopSnackBar Tests', () {
    tearDown(() {
      AppTopSnackBar.dismiss();
    });

    testWidgets('shows message and can be dismissed via close button',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AppTopSnackBar.show(
                  context: context,
                  message: 'رسالة إشعار تجريبية',
                  icon: Iconsax.notification,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      expect(find.text('رسالة إشعار تجريبية'), findsNothing);

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('رسالة إشعار تجريبية'), findsOneWidget);
      expect(find.byIcon(Iconsax.notification), findsOneWidget);
      expect(find.byIcon(Iconsax.close_circle), findsOneWidget);

      // Tap close button to dismiss
      await tester.tap(find.byIcon(Iconsax.close_circle));
      await tester.pumpAndSettle();

      expect(find.text('رسالة إشعار تجريبية'), findsNothing);
    });

    testWidgets('showSuccess renders emerald success styling and auto dismisses',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AppTopSnackBar.showSuccess(
                  context: context,
                  message: 'تم بنجاح',
                  duration: const Duration(seconds: 1),
                );
              },
              child: const Text('Success'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Success'));
      await tester.pumpAndSettle();

      expect(find.text('تم بنجاح'), findsOneWidget);
      expect(find.byIcon(Iconsax.tick_circle), findsOneWidget);

      // Advance clock past auto-dismiss duration
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('تم بنجاح'), findsNothing);
    });

    testWidgets('showError renders error styling and replaces previous toast',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    AppTopSnackBar.showSuccess(
                      context: context,
                      message: 'الأول',
                      duration: const Duration(seconds: 1),
                    );
                  },
                  child: const Text('First'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppTopSnackBar.showError(
                      context: context,
                      message: 'حدث خطأ',
                      duration: const Duration(seconds: 1),
                    );
                  },
                  child: const Text('Second'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('First'));
      await tester.pumpAndSettle();
      expect(find.text('الأول'), findsOneWidget);

      // Second toast replaces first
      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();
      expect(find.text('الأول'), findsNothing);
      expect(find.text('حدث خطأ'), findsOneWidget);
      expect(find.byIcon(Iconsax.warning_2), findsOneWidget);

      // Advance clock to clean up timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('حدث خطأ'), findsNothing);
    });
  });
}
