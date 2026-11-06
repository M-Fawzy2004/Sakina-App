import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double height = 1.5,
}) =>
    GoogleFonts.almarai(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );

// ─── HADITH LARGE (4×4) ─────────────────────────────────────────────────────
class HadithLargeWidgetView extends StatelessWidget {
  final WidgetHadithData data;
  const HadithLargeWidgetView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGoldDim,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('حديث اليوم',
                        style: _almarai(size: 12, color: _kGold, weight: FontWeight.bold)),
                  ),
                  Flexible(
                    child: Text(data.sourceBook,
                        style: _almarai(size: 11, color: _kSubText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Topic chip
              if (data.topic.isNotEmpty)
                Text(data.topic,
                    style: _almarai(size: 11, color: _kGold, weight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              // Narrator
              if (data.narrator.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(data.narrator,
                      style: _almarai(size: 11, color: _kSubText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              const SizedBox(height: 10),
              // Divider
              Container(height: 1, color: _kBorder),
              const SizedBox(height: 10),
              // Hadith body
              Expanded(
                child: Text(data.text,
                    style: _almarai(size: 14, height: 1.75),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis),
              ),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(data.narrator,
                        style: _almarai(size: 10, color: _kSubText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text('سَكِينَة',
                      style: _almarai(size: 10, color: _kGold, weight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        child: Container(
          width: 360,
          height: 170,
          color: _kBg,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('حديث اليوم',
                      style: _almarai(size: 11, color: _kGold, weight: FontWeight.bold)),
                  Text(data.sourceBook,
                      style: _almarai(size: 10, color: _kSubText)),
                ],
              ),
              Container(margin: const EdgeInsets.symmetric(vertical: 6), height: 1, color: _kBorder),
              Expanded(
                child: Text(data.text,
                    style: _almarai(size: 13, height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(data.narrator,
                        style: _almarai(size: 10, color: _kSubText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text('سَكِينَة',
                      style: _almarai(size: 10, color: _kGold, weight: FontWeight.bold)),
                ],
              ),
            ],
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
        child: Container(
          width: 170,
          height: 170,
          color: _kBg,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('حديث اليوم',
                  style: _almarai(size: 10, color: _kGold, weight: FontWeight.bold)),
              Container(margin: const EdgeInsets.symmetric(vertical: 5), height: 1, color: _kBorder),
              Expanded(
                child: Text(data.text,
                    style: _almarai(size: 11, height: 1.5),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 4),
              Text(data.sourceBook,
                  style: _almarai(size: 9.5, color: _kSubText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
