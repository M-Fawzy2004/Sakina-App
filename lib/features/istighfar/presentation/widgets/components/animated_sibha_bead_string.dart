import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Luxury Realistic 3D Misbaha (Digital Tasbih) Widget.
///
/// Senior UI/UX Architecture:
/// 1. True Hanging U-Arc: Drooping necklace catenary curve with lowest apex at bottom center.
/// 2. Seamless Gesture Handling: Pointer listener that guarantees 100% tap responsiveness
///    and fluid horizontal drag without gesture arena swallowing.
/// 3. Perpetual Angular Progression: Every tap—slow or fast—visibly advances the beads
///    by exactly 1 position without snaps or stutter.
/// 4. High-End 3D Pearl Spheres: Rich radial gradient, ivory highlights, pure specular glints,
///    and clean contours without artificial black slice lines or drop shadows.
/// 5. Concentric Gold Focal Marker: Directly framing the center active bead at the trough.
/// 6. Floating `+1` Particle: Gracefully ascends and fades on each increment.
class AnimatedSibhaBeadString extends StatefulWidget {
  final int count;
  final VoidCallback onTap;

  const AnimatedSibhaBeadString({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  State<AnimatedSibhaBeadString> createState() =>
      _AnimatedSibhaBeadStringState();
}

class _AnimatedSibhaBeadStringState extends State<AnimatedSibhaBeadString>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _plusOneController;
  late Animation<double> _slideAnimation;
  late Animation<double> _plusOneAnimation;

  double _fromOffset = 0.0;
  double _toOffset = 0.0;
  double _currentOffset = 0.0;

  double _dragStartX = 0.0;
  double _dragDeltaX = 0.0;
  bool _isDragging = false;
  bool _showPlusOne = false;

  @override
  void initState() {
    super.initState();
    _fromOffset = widget.count.toDouble();
    _toOffset = widget.count.toDouble();
    _currentOffset = widget.count.toDouble();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );

    _plusOneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _plusOneAnimation = CurvedAnimation(
      parent: _plusOneController,
      curve: Curves.easeOutCubic,
    );

    _slideController.addListener(() {
      setState(() {
        _currentOffset =
            _fromOffset + (_toOffset - _fromOffset) * _slideAnimation.value;
      });
    });

    _plusOneController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _showPlusOne = false;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedSibhaBeadString oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _fromOffset = _currentOffset;
      _toOffset = widget.count.toDouble();
      _dragDeltaX = 0.0;
      _slideController.forward(from: 0.0);

      _showPlusOne = true;
      _plusOneController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _plusOneController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _dragStartX = event.position.dx;
    _dragDeltaX = 0.0;
    _isDragging = true;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final delta = event.position.dx - _dragStartX;
    if (_isDragging && delta.abs() > 4.0) {
      setState(() {
        _dragDeltaX = delta;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final delta = _dragDeltaX;
    _isDragging = false;
    _dragDeltaX = 0.0;

    // If dragged significantly (> 20px) or simple tap (< 10px), trigger tasbeeh
    if (delta.abs() > 20.0 || delta.abs() < 10.0) {
      widget.onTap();
    } else {
      setState(() {});
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _isDragging = false;
    _dragDeltaX = 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Convert drag pixel displacement into proportional bead step progress
    final dragStepProgress = (-_dragDeltaX / 80.0).clamp(-1.0, 1.0);
    final renderedOffset =
        _isDragging ? (_currentOffset + dragStepProgress) : _currentOffset;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 165.h,
        width: double.infinity,
        child: CustomPaint(
          painter: _HangingSibhaPainter(
            currentOffset: renderedOffset,
            plusOneProgress: _showPlusOne ? _plusOneAnimation.value : 1.0,
            showPlusOne: _showPlusOne,
            colors: colors,
          ),
          size: Size(double.infinity, 165.h),
        ),
      ),
    );
  }
}

/// Custom painter rendering the hanging U-arc, continuous beads, and focal rings.
class _HangingSibhaPainter extends CustomPainter {
  final double currentOffset;
  final double plusOneProgress;
  final bool showPlusOne;
  final AppColorsScheme colors;

  static const int _visibleRange = 6; // -6 to +6 beads around apex
  static const double _step = 0.24; // angular gap between adjacent beads

  _HangingSibhaPainter({
    required this.currentOffset,
    required this.plusOneProgress,
    required this.showPlusOne,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = 12.h;
    final radiusX = size.width * 0.45;
    final radiusY = 112.h;
    final focalY = centerY + radiusY; // Lowest point at center (124.h)

    // 1. Draw hanging golden silk cord (clean U-curve)
    final cordPaint = Paint()
      ..color = colors.accentGold.withValues(alpha: 0.40)
      ..strokeWidth = 2.0.r
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i <= 50; i++) {
      // phi from -1.22 rad to +1.22 rad
      final phi = -1.22 + (i / 50.0) * 2.44;
      final x = centerX + radiusX * math.sin(phi);
      final y = centerY + radiusY * math.cos(phi);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, cordPaint);

    // 2. Draw Center Active Bead Marker (المحبس الذهبي - concentric rings at bottom apex)
    final outerRing = Paint()
      ..color = colors.accentGold.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.r;
    canvas.drawCircle(Offset(centerX, focalY), 30.r, outerRing);

    final innerRing = Paint()
      ..color = colors.accentGold.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6.r;
    canvas.drawCircle(Offset(centerX, focalY), 25.r, innerRing);

    // 3. Draw Beads along the hanging arc with continuous sliding offset
    final centerIdx = currentOffset.round();

    for (int j = -_visibleRange; j <= _visibleRange; j++) {
      final int beadIndex = centerIdx + j;
      // phi = 0 is center apex. As count increases, incoming beads slide right to left
      final double phi = (beadIndex - currentOffset) * _step;

      // Cull beads that wrap past visible hanging arc
      if (phi < -1.24 || phi > 1.24) continue;

      final double bx = centerX + radiusX * math.sin(phi);
      final double by = centerY + radiusY * math.cos(phi);

      final double distFromApex = phi.abs();

      // Optical perspective scale: 1.0 at center -> 0.58 at extremities
      final double scale =
          (1.0 - (distFromApex / 1.24) * 0.42).clamp(0.58, 1.0);

      // Optical depth of field: 1.0 at center -> 0.42 at extremities
      final double opacity =
          (1.0 - (distFromApex / 1.24) * 0.58).clamp(0.42, 1.0);

      final double beadRadius = (19.0.r * scale);
      final bool isCenterFocal = distFromApex < (_step * 0.40);

      _drawSingleBead(
        canvas: canvas,
        center: Offset(bx, by),
        radius: beadRadius,
        scale: scale,
        opacity: opacity,
        isCenter: isCenterFocal,
      );
    }

    // 4. Draw Floating `+1` particle on increment
    if (showPlusOne && plusOneProgress < 1.0) {
      _drawFloatingPlusOne(
        canvas: canvas,
        position: Offset(
          centerX + 18.w,
          focalY - 14.h - (24.h * plusOneProgress),
        ),
        opacity: (1.0 - plusOneProgress).clamp(0.0, 1.0),
      );
    }
  }

  void _drawSingleBead({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double scale,
    required double opacity,
    required bool isCenter,
  }) {
    // 1. Uniform radiant golden-amber 3D pearl sphere (Zero shadow)
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Color highlight = AppColors.paleRadiance.withValues(alpha: opacity);
    final Color body = colors.accentGold.withValues(alpha: opacity);
    final Color deepTone = AppColors.warmGold.withValues(alpha: opacity);

    final beadPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.88,
        colors: [
          highlight,
          body,
          deepTone,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius, beadPaint);

    // 2. Perimeter Border (clean, crisp luxury gold rim)
    final borderPaint = Paint()
      ..color = (isCenter ? AppColors.paleRadiance : colors.accentGold)
          .withValues(alpha: (isCenter ? 0.95 : 0.70) * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isCenter ? 2.0.r : 1.1.r) * scale;
    canvas.drawCircle(center, radius, borderPaint);

    // 3. Specular Glint Reflection on Top-Left of every bead
    final glintPaint = Paint()
      ..color = AppColors.pureChalk
          .withValues(alpha: (isCenter ? 0.90 : 0.65) * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.32, center.dy - radius * 0.32),
      radius * 0.22,
      glintPaint,
    );
  }

  void _drawFloatingPlusOne({
    required Canvas canvas,
    required Offset position,
    required double opacity,
  }) {
    final textSpan = TextSpan(
      text: '+1',
      style: GoogleFonts.cairo(
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w800,
        color: colors.accentGold.withValues(alpha: opacity),
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _HangingSibhaPainter oldDelegate) {
    return oldDelegate.currentOffset != currentOffset ||
        oldDelegate.plusOneProgress != plusOneProgress ||
        oldDelegate.showPlusOne != showPlusOne ||
        oldDelegate.colors != colors;
  }
}
