import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/theme_mode_selector_card.dart';

void main() {
  Widget buildTestableWidget({
    required AppThemeMode currentMode,
    required ValueChanged<AppThemeMode> onModeChanged,
    bool isDark = true,
  }) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          theme: isDark ? AppTheme.darkLuxury : AppTheme.lightLuxury,
          home: Scaffold(
            body: Center(
              child: ThemeModeSelectorCard(
                currentMode: currentMode,
                onModeChanged: onModeChanged,
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('ThemeModeSelectorCard renders all 5 theme options and triggers tap', (tester) async {
    AppThemeMode? selectedMode;

    await tester.pumpWidget(
      buildTestableWidget(
        currentMode: AppThemeMode.charcoal,
        onModeChanged: (mode) => selectedMode = mode,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('مَظْهَرُ التَّطْبِيقِ'), findsOneWidget);
    expect(find.text('الفَحْمِيُّ'), findsOneWidget);
    expect(find.text('الداكن'), findsOneWidget);
    expect(find.text('رَقُّ السَّكِينَةِ'), findsOneWidget);
    expect(find.text('زُمُرُّدُ الفِرْدَوْسِ'), findsOneWidget);
    expect(find.text('تلقائي'), findsOneWidget);

    // Tap on Light Theme
    await tester.ensureVisible(find.text('رَقُّ السَّكِينَةِ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('رَقُّ السَّكِينَةِ'));
    await tester.pumpAndSettle();
    expect(selectedMode, AppThemeMode.light);

    // Tap on Royal Emerald Theme
    await tester.ensureVisible(find.text('زُمُرُّدُ الفِرْدَوْسِ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('زُمُرُّدُ الفِرْدَوْسِ'));
    await tester.pumpAndSettle();
    expect(selectedMode, AppThemeMode.emerald);

    // Tap on Charcoal Theme
    await tester.ensureVisible(find.text('الفَحْمِيُّ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الفَحْمِيُّ'));
    await tester.pumpAndSettle();
    expect(selectedMode, AppThemeMode.charcoal);
  });
}
