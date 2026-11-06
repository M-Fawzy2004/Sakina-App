import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

// ─── HELPERS ──────────────────────────────────────────────────────────────────

/// Splits "4:44 ص" into ("4:44", "ص"). If there is no suffix, suffix is empty.
({String main, String suffix}) splitTime12(String time) {
  final parts = time.trim().split(RegExp(r'\s+'));
  if (parts.length < 2) return (main: time.trim(), suffix: '');
  return (main: parts.first, suffix: parts.sublist(1).join(' '));
}

// ─── FRAME + PATTERN ──────────────────────────────────────────────────────────

/// Shared luxury frame for every home widget:
/// charcoal base, thin gold outer border, hairline inner border and a very
/// subtle Islamic star lattice. One colour (gold) only, no shadows.
class WidgetFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const WidgetFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.charcoalCore,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.champagneGold.withValues(alpha: 0.7),
          width: 1.4,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: AppColors.champagneGold.withValues(alpha: 0.22),
              width: 0.7,
            ),
          ),
          child: CustomPaint(
            painter: const IslamicPatternPainter(),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  const IslamicPatternPainter();

  static const double _tile = 28;
  static const double _r = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = AppColors.champagneGold.withValues(alpha: 0.075);
    final dot = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.champagneGold.withValues(alpha: 0.09);

    final d = _r * math.sqrt2;
    // Eight-pointed star = square + square rotated by 45°
    final star = Path()
      ..moveTo(-_r, -_r)
      ..lineTo(_r, -_r)
      ..lineTo(_r, _r)
      ..lineTo(-_r, _r)
      ..close()
      ..moveTo(0, -d)
      ..lineTo(d, 0)
      ..lineTo(0, d)
      ..lineTo(-d, 0)
      ..close();

    for (double y = 0; y <= size.height + _tile; y += _tile) {
      for (double x = 0; x <= size.width + _tile; x += _tile) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawPath(star, stroke);
        canvas.restore();
        canvas.drawCircle(Offset(x + _tile / 2, y + _tile / 2), 1.1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── SMALL BUILDING BLOCKS ────────────────────────────────────────────────────

class WidgetTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;
  final double iconSize;

  const WidgetTitle({
    super.key,
    required this.icon,
    required this.text,
    this.fontSize = 12,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.champagneGold, size: iconSize),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.almarai(
            fontSize: fontSize,
            color: AppColors.champagneGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class WidgetPill extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool filled;

  const WidgetPill({
    super.key,
    required this.text,
    this.fontSize = 10,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2.5),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.champagneGold.withValues(alpha: 0.14)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.champagneGold.withValues(alpha: 0.45),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.almarai(
          fontSize: fontSize,
          color: filled ? AppColors.champagneGold : AppColors.pureChalk,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class WidgetBrandMark extends StatelessWidget {
  final double fontSize;

  const WidgetBrandMark({super.key, this.fontSize = 10.5});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 4.5,
            height: 4.5,
            color: AppColors.champagneGold,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'سَكِينَة',
          style: GoogleFonts.almarai(
            fontSize: fontSize,
            color: AppColors.champagneGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Thin gold line fading out on both sides with a small diamond in the middle.
class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key});

  Widget _line({required bool rightSide}) {
    final gold = AppColors.champagneGold;
    return Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: rightSide ? Alignment.centerRight : Alignment.centerLeft,
            end: rightSide ? Alignment.centerLeft : Alignment.centerRight,
            colors: [gold.withValues(alpha: 0.0), gold.withValues(alpha: 0.55)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _line(rightSide: true),
        const SizedBox(width: 6),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(width: 5, height: 5, color: AppColors.champagneGold),
        ),
        const SizedBox(width: 6),
        _line(rightSide: false),
      ],
    );
  }
}

/// Centered text that shrinks to fit its box instead of being cut with "…".
class AutoFitText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const AutoFitText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, box) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: box.maxWidth,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: style,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
