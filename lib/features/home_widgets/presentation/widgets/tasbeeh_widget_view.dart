import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/utils/arabic_numerals.dart';
import 'package:sakina_app/features/home_widgets/domain/models/widget_models.dart';

// ─── Shared design tokens ────────────────────────────────────────────────────
const _kBg = Color(0xFF0C1120);
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

// ─── TASBEEH SMALL (2×2) ────────────────────────────────────────────────────
class TasbeehSmallWidgetView extends StatelessWidget {
  final WidgetTasbeehData data;

  const TasbeehSmallWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 170,
          height: 170,
          color: _kBg,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'التسبيح اليومي',
                      style: _almarai(
                          size: 11, color: _kGold, weight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      data.shortTitle,
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
              const SizedBox(height: 6),

              // ── Phrase ───────────────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Text(
                    data.phrase,
                    textAlign: TextAlign.center,
                    style: _almarai(
                        size: 13,
                        color: _kText,
                        weight: FontWeight.bold,
                        height: 1.55),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // ── Target pill ──────────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _kGoldDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _kGold.withAlpha(80)),
                ),
                child: Center(
                  child: Text(
                    'الهدف: ${ArabicNumerals.format(data.targetCount)} مرة \u2022 اضغط للبدء',
                    style: _almarai(
                        size: 9.5, color: _kGold, weight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
