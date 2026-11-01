import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_theme.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_celestial_sliver_header.dart';

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

  const testHeaderData = MaladhHeaderData(
    greetingTitle: 'صَبَاحُ السَّكِينَةِ',
    greetingSubtitle: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
    hijriDate: '21 جمادى الأولى',
    gregorianDate: '01 نوفمبر 2026',
    dailyVerseText: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
    dailyVerseSurah: 'سُورَةُ المُطَفِّفِينَ • آيَة 26',
    nextPrayerName: 'الظُّهْرُ',
    nextPrayerTimeRemaining: 'بَعْدَ 3 سَاعَات',
    streakDays: 5,
  );

  group('MaladhCelestialSliverHeader Widget Tests', () {
    testWidgets('renders celestial header with holy ayah, surah source, and brand crest', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const CustomScrollView(
            slivers: [
              MaladhCelestialSliverHeader(
                data: testHeaderData,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Sakina Brand Title
      expect(find.text('سَكِينَة'), findsOneWidget);
      expect(find.text('مَلَاذُ الرُّوحِ'), findsOneWidget);

      // Verify Holy Quranic Ayah
      expect(find.text('وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ'), findsOneWidget);
      expect(find.text('سُورَةُ المُطَفِّفِينَ • آيَة 26'), findsOneWidget);

      // Verify notification icon is NOT rendered
      expect(find.byIcon(Iconsax.notification), findsNothing);
    });

    testWidgets('triggers onPlayVerseTap callback when recitation button is tapped', (tester) async {
      bool playTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          CustomScrollView(
            slivers: [
              MaladhCelestialSliverHeader(
                data: testHeaderData,
                onPlayVerseTap: () {
                  playTapped = true;
                },
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playFinder = find.byIcon(Icons.play_arrow_rounded);
      expect(playFinder, findsOneWidget);

      await tester.tap(playFinder);
      await tester.pumpAndSettle();

      expect(playTapped, isTrue);
    });

    testWidgets('smoothly collapses when scrolling without overflow or layout exception', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          CustomScrollView(
            slivers: [
              const MaladhCelestialSliverHeader(
                data: testHeaderData,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 1200,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll up by 300 pixels to fully collapse the sliver header
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Verify the header remains pinned with brand identity intact
      expect(find.text('سَكِينَة'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
