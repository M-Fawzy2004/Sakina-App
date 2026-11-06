import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/utils/arabic_numerals.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';

// ─── Shared design tokens ────────────────────────────────────────────────────
const _kBg = Color(0xFF0C1120);
const _kCard = Color(0xFF141B2D);
const _kGold = Color(0xFFD4AF37);
const _kGoldDim = Color(0x33D4AF37);
const _kText = Colors.white;
const _kSubText = Color(0xFF94A3B8);
const _kBorder = Color(0x1FD4AF37);

TextStyle _almarai({
  double size = 13,
  Color color = _kText,
  FontWeight weight = FontWeight.w500,
  double height = 1.4,
}) =>
    GoogleFonts.almarai(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );

// ─── QURAN LARGE (4×4) ──────────────────────────────────────────────────────
class QuranLargeWidgetView extends StatelessWidget {
  final WidgetQuranData data;

  const QuranLargeWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final formattedAyahNum = ArabicNumerals.format(data.ayahNumber);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 360,
          height: 360,
          color: _kBg,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGoldDim,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'آية اليوم',
                      style: _almarai(
                          size: 12, color: _kGold, weight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${data.surahName} \u2022 آية $formattedAyahNum',
                      style: _almarai(size: 11, color: _kSubText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Thin divider ─────────────────────────────────────────────
              Container(height: 1, color: _kBorder),
              const SizedBox(height: 14),

              // ── Quranic Text ─────────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Text(
                    '${data.arabicText} \u{FD3E}$formattedAyahNum\u{FD3F}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiriQuran(
                      color: _kText,
                      fontSize: 19,
                      height: 2.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Reflection card ──────────────────────────────────────────
              if (data.reflection.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _kCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وقفة تدبرية',
                        style: _almarai(
                            size: 11, color: _kGold, weight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.reflection,
                        style: _almarai(size: 12, color: _kSubText, height: 1.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── QURAN MEDIUM (4×2) ─────────────────────────────────────────────────────
class QuranMediumWidgetView extends StatelessWidget {
  final WidgetQuranData data;

  const QuranMediumWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final formattedAyahNum = ArabicNumerals.format(data.ayahNumber);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 360,
          height: 170,
          color: _kBg,
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'آية اليوم',
                    style: _almarai(
                        size: 12, color: _kGold, weight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${data.surahName} \u2022 آية $formattedAyahNum',
                      style: _almarai(size: 10, color: _kSubText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // ── Thin divider ─────────────────────────────────────────────
              Container(height: 1, color: _kBorder),
              const SizedBox(height: 8),

              // ── Quranic Text ─────────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Text(
                    '${data.arabicText} \u{FD3E}$formattedAyahNum\u{FD3F}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiriQuran(
                      color: _kText,
                      fontSize: 15,
                      height: 1.8,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // ── Footer ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data.surahName,
                      style: _almarai(size: 10, color: _kSubText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'سَكِينَة',
                    style: _almarai(
                        size: 10, color: _kGold, weight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
