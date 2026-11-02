import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';
import 'package:sakina_app/features/quran_reading/presentation/widgets/components/quran_islamic_rosette_badge.dart';

/// Continuous flowing Mushaf scripture with inline Islamic rosette badges
/// and real-time active recitation highlighting ("تظليل الآية التي تُتلى حالياً").
class QuranContinuousManuscriptFlow extends StatefulWidget {
  final List<AyahEntity> verses;
  final QuranReaderPreferences preferences;
  final int? selectedAyahNumber;
  final int? recitingAyahNumber;
  final ValueChanged<int> onAyahTap;

  const QuranContinuousManuscriptFlow({
    super.key,
    required this.verses,
    required this.preferences,
    required this.selectedAyahNumber,
    required this.recitingAyahNumber,
    required this.onAyahTap,
  });

  @override
  State<QuranContinuousManuscriptFlow> createState() =>
      _QuranContinuousManuscriptFlowState();
}

class _QuranContinuousManuscriptFlowState
    extends State<QuranContinuousManuscriptFlow> {
  final Map<int, TapGestureRecognizer> _recognizers = {};

  @override
  void initState() {
    super.initState();
    _rebuildRecognizers();
  }

  @override
  void didUpdateWidget(covariant QuranContinuousManuscriptFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.verses != widget.verses ||
        oldWidget.onAyahTap != widget.onAyahTap) {
      _disposeRecognizers();
      _rebuildRecognizers();
    }
  }

  void _rebuildRecognizers() {
    for (final ayah in widget.verses) {
      _recognizers[ayah.numberInSurah] = TapGestureRecognizer()
        ..onTap = () => widget.onAyahTap(ayah.numberInSurah);
    }
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.preferences.theme;
    final fontSize = 22.sp + widget.preferences.fontSize.scaleDelta;
    final lineSpacing = widget.preferences.lineSpacing.height;
    final badgeSize =
        (28.r + widget.preferences.fontSize.scaleDelta * 0.9).clamp(24.r, 44.r);

    final spans = <InlineSpan>[];

    for (final ayah in widget.verses) {
      final isSelected = widget.selectedAyahNumber == ayah.numberInSurah;
      final isReciting = widget.recitingAyahNumber == ayah.numberInSurah;
      final recognizer = _recognizers[ayah.numberInSurah];

      // Ayah Text with active recitation highlight
      spans.add(
        TextSpan(
          text: '${ayah.textForStyle(widget.preferences.scriptStyle)} ',
          recognizer: recognizer,
          style: AppTextStyles.quranScriptStyleOf(widget.preferences.scriptStyle)
              .copyWith(
            fontSize: fontSize,
            height: lineSpacing,
            color: (isSelected || isReciting)
                ? theme.accentColor
                : theme.textColor,
            backgroundColor: isReciting
                ? theme.accentColor.withValues(alpha: 0.25)
                : (isSelected
                    ? theme.accentColor.withValues(alpha: 0.18)
                    : Colors.transparent),
            fontWeight:
                (isSelected || isReciting) ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      );

      // Inline Rosette Badge
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => widget.onAyahTap(ayah.numberInSurah),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: QuranIslamicRosetteBadge(
                number: ayah.numberInSurah,
                isHighlighted: isSelected || isReciting,
                color: (isSelected || isReciting)
                    ? theme.accentColor
                    : theme.accentColor.withValues(alpha: 0.9),
                backgroundColor: theme.cardColor,
                size: badgeSize,
              ),
            ),
          ),
        ),
      );

      spans.add(const TextSpan(text: ' '));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.justify,
          strutStyle: StrutStyle(
            fontSize: fontSize,
            height: lineSpacing,
            forceStrutHeight: true,
          ),
        ),
      ),
    );
  }
}

