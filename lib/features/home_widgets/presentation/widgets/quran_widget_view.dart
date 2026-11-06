import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/utils/arabic_numerals.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/widget_common.dart';

// ─── QURAN MEDIUM (4×2) ─────────────────────────────────────────────────────

class QuranMediumWidgetView extends StatelessWidget {
  final WidgetQuranData data;

  const QuranMediumWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ayahNum = ArabicNumerals.format(data.ayahNumber);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 360,
          height: 170,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(18, 11, 18, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const WidgetTitle(
                      icon: Icons.auto_stories_rounded,
                      text: 'آيَةُ اليَوْم',
                      fontSize: 12.5,
                      iconSize: 15,
                    ),
                    const Spacer(),
                    Flexible(
                      child: WidgetPill(
                        text: '${data.surahName} \u2022 آية $ayahNum',
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const OrnamentDivider(),
                Expanded(
                  child: AutoFitText(
                    text: '${data.arabicText} \uFD3E$ayahNum\uFD3F',
                    maxLines: 4,
                    style: GoogleFonts.amiriQuran(
                      fontSize: 17,
                      color: AppColors.pureChalk,
                      height: 1.9,
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [WidgetBrandMark(fontSize: 10.5)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── QURAN SMALL (2×2) ──────────────────────────────────────────────────────

class QuranSmallWidgetView extends StatelessWidget {
  final WidgetQuranData data;

  const QuranSmallWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ayahNum = ArabicNumerals.format(data.ayahNumber);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 170,
          height: 170,
          child: WidgetFrame(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const WidgetTitle(
                      icon: Icons.auto_stories_rounded,
                      text: 'آية اليوم',
                      fontSize: 10.5,
                      iconSize: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data.surahName,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.almarai(
                          fontSize: 9,
                          color: AppColors.mutedSilver,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const OrnamentDivider(),
                Expanded(
                  child: AutoFitText(
                    text: '${data.arabicText} \uFD3E$ayahNum\uFD3F',
                    maxLines: 6,
                    style: GoogleFonts.amiriQuran(
                      fontSize: 13.5,
                      color: AppColors.pureChalk,
                      height: 1.8,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'آية $ayahNum',
                        style: GoogleFonts.almarai(
                          fontSize: 8.5,
                          color: AppColors.mutedSilver,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const WidgetBrandMark(fontSize: 9),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}