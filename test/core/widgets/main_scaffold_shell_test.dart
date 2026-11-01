import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/widgets/navigation/main_scaffold_shell.dart';
import 'package:sakina_app/core/widgets/navigation/sakina_bottom_nav_bar.dart';

class _FakeStatefulNavigationShell extends StatefulWidget
    implements StatefulNavigationShell {
  @override
  final int currentIndex;
  final ValueChanged<int>? onGoBranch;

  const _FakeStatefulNavigationShell({
    this.currentIndex = 0,
    this.onGoBranch,
  });

  @override
  void goBranch(int index, {bool initialLocation = false}) {
    onGoBranch?.call(index);
  }

  @override
  State<_FakeStatefulNavigationShell> createState() =>
      _FakeStatefulNavigationShellState();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStatefulNavigationShellState
    extends State<_FakeStatefulNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) => SizedBox(
        height: 60,
        child: Text('Item $index'),
      ),
    );
  }
}

void main() {
  Widget buildTestShell({
    required StatefulNavigationShell shell,
    EdgeInsets mediaPadding = EdgeInsets.zero,
  }) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            padding: mediaPadding,
            size: const Size(390, 844),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MainScaffoldShell(navigationShell: shell),
          ),
        ),
      ),
    );
  }

  group('MainScaffoldShell Tests', () {
    testWidgets('renders bottom navigation bar and responds to tab tap',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      int? tappedIndex;
      final fakeShell = _FakeStatefulNavigationShell(
        currentIndex: 0,
        onGoBranch: (idx) => tappedIndex = idx,
      );

      await tester.pumpWidget(buildTestShell(shell: fakeShell));
      await tester.pumpAndSettle();

      expect(find.byType(SakinaBottomNavBar), findsOneWidget);
      expect(find.text('المَلَاذُ'), findsOneWidget);
      expect(find.text('المُصْحَفُ'), findsOneWidget);

      await tester.tap(find.text('المُصْحَفُ'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 1);
    });

    testWidgets('elevates bottom bar on iPhone with safe area bottom padding',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const iphoneSafeArea = EdgeInsets.only(bottom: 34.0);
      const fakeShell = _FakeStatefulNavigationShell(currentIndex: 0);

      await tester.pumpWidget(
        buildTestShell(shell: fakeShell, mediaPadding: iphoneSafeArea),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SakinaBottomNavBar), findsOneWidget);
    });

    testWidgets('shows scroll-to-top button on Quran reading tab (index 1) when scrolled past threshold',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const fakeShell = _FakeStatefulNavigationShell(currentIndex: 1);

      await tester.pumpWidget(buildTestShell(shell: fakeShell));
      await tester.pumpAndSettle();

      final arrowFinder = find.byIcon(Iconsax.arrow_up_3);
      expect(arrowFinder, findsOneWidget);

      // Scroll down substantially (over 650 px)
      await tester.drag(find.byType(ListView), const Offset(0, -700));
      await tester.pumpAndSettle();

      // Tap scroll-to-top
      await tester.tap(arrowFinder);
      await tester.pumpAndSettle();
    });
  });
}
