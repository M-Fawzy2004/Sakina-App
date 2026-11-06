import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';
import 'package:sakina_app/features/home_widgets/presentation/widgets/widget_common.dart';

// ─── HADITH MEDIUM (4×2) ────────────────────────────────────────────────────

class HadithMediumWidgetView extends StatelessWidget {
  final WidgetHadithData data;

  const HadithMediumWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                      icon: Icons.menu_book_rounded,
                      text: 'حَدِيثُ اليَوْم',
                      fontSize: 12.5,
                      iconSize: 15,
                    ),
                    const Spacer(),
                    if (data.sourceBook.isNotEmpty)
                      Flexible(
                        child: WidgetPill(text: data.sourceBook, fontSize: 10),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                const OrnamentDivider(),
                Expanded(
                  child: AutoFitText(
                    text: '« ${data.text} »',
                    maxLines: 5,
                    style: GoogleFonts.amiri(
                      fontSize: 16,
                      color: AppColors.pureChalk,
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.narrator,
                        style: GoogleFonts.almarai(
                          fontSize: 10,
                          color: AppColors.mutedSilver,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const WidgetBrandMark(fontSize: 10.5),
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

// ─── HADITH SMALL (2×2) ─────────────────────────────────────────────────────

class HadithSmallWidgetView extends StatelessWidget {
  final WidgetHadithData data;

  const HadithSmallWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                      icon: Icons.menu_book_rounded,
                      text: 'حديث اليوم',
                      fontSize: 10.5,
                      iconSize: 12,
                    ),
                    if (data.sourceBook.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.sourceBook,
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
                  ],
                ),
                const SizedBox(height: 5),
                const OrnamentDivider(),
                Expanded(
                  child: AutoFitText(
                    text: '« ${data.text} »',
                    maxLines: 7,
                    style: GoogleFonts.amiri(
                      fontSize: 13,
                      color: AppColors.pureChalk,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.narrator,
                        style: GoogleFonts.almarai(
                          fontSize: 8.5,
                          color: AppColors.mutedSilver,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
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