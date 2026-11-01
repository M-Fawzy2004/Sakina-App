import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Breathtaking dark-luxury live sanctuary medallion with multi-ring animated spiritual aura.
/// Built with zero drop-shadows, pure border radiance, and authentic Islamic geometric watermark.
class LiveSanctuaryAuraMedallion extends StatefulWidget {
  final bool isMakkah;
  final bool isPlaying;
  final Animation<double> rotationAnimation;

  const LiveSanctuaryAuraMedallion({
    super.key,
    required this.isMakkah,
    required this.isPlaying,
    required this.rotationAnimation,
  });

  @override
  State<LiveSanctuaryAuraMedallion> createState() => _LiveSanctuaryAuraMedallionState();
}

class _LiveSanctuaryAuraMedallionState extends State<LiveSanctuaryAuraMedallion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    if (widget.isPlaying) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant LiveSanctuaryAuraMedallion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryAccent = widget.isMakkah
        ? AppColors.champagneGold
        : AppColors.emeraldGlow;

    return SizedBox(
      width: 250.r,
      height: 250.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Concentric Animated Aura Rings (Radiating spiritual ripple waves)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _AuraRippleRing(
                    animationValue: _pulseController.value,
                    delayFraction: 0.0,
                    color: primaryAccent,
                    isPlaying: widget.isPlaying,
                  ),
                  _AuraRippleRing(
                    animationValue: _pulseController.value,
                    delayFraction: 0.35,
                    color: primaryAccent,
                    isPlaying: widget.isPlaying,
                  ),
                  _AuraRippleRing(
                    animationValue: _pulseController.value,
                    delayFraction: 0.7,
                    color: primaryAccent,
                    isPlaying: widget.isPlaying,
                  ),
                ],
              );
            },
          ),

          // 2. Central Sanctuary Medallion
          Container(
            width: 184.r,
            height: 184.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isPlaying ? primaryAccent : AppColors.goldBorderStroke,
                width: 2.r,
              ),
              gradient: RadialGradient(
                colors: widget.isMakkah
                    ? const [
                        AppColors.carbonSlate,
                        AppColors.obsidianCore,
                      ]
                    : const [
                        AppColors.deepSanctuary,
                        AppColors.obsidianCore,
                      ],
              ),
            ),
            padding: EdgeInsets.all(5.r),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.goldBorderStroke,
                  width: 1.5.r,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating Islamic Rosette Watermark
                  RotationTransition(
                    turns: widget.rotationAnimation,
                    child: CustomPaint(
                      size: Size(160.r, 160.r),
                      painter: _SanctuaryWatermarkPainter(color: primaryAccent),
                    ),
                  ),

                  // Center Sacred Typography & Sanctuary Icon
                  Padding(
                    padding: EdgeInsets.all(12.r),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sacred Sanctuary Emblem
                          Text(
                            widget.isMakkah ? '🕋' : '🕌',
                            style: TextStyle(
                              fontSize: 38.sp,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Sacred Inscription
                          Text(
                            widget.isMakkah ? 'المسجد الحرام' : 'المسجد النبوي',
                            style: GoogleFonts.amiri(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.paleRadiance,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            widget.isMakkah ? 'الكعبة المشرفة' : 'الروضة الشريفة',
                            style: GoogleFonts.cairo(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.isMakkah
                                  ? AppColors.champagneGold
                                  : AppColors.emeraldGlow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Concentric expanding aura ripple ring for the live broadcast
class _AuraRippleRing extends StatelessWidget {
  final double animationValue;
  final double delayFraction;
  final Color color;
  final bool isPlaying;

  const _AuraRippleRing({
    required this.animationValue,
    required this.delayFraction,
    required this.color,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPlaying) {
      return const SizedBox.shrink();
    }

    final effectiveValue = (animationValue - delayFraction) % 1.0;
    final progress = effectiveValue < 0 ? effectiveValue + 1.0 : effectiveValue;

    // Radius expands smoothly from 186 to 244
    final size = 186.r + (progress * 58.r);
    // Opacity fades smoothly from 0.40 to 0.0
    final opacity = (1.0 - progress) * 0.40;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: opacity),
          width: 1.5.r,
        ),
      ),
    );
  }
}

/// Geometric 8-pointed star watermark for sanctuary emblem background
class _SanctuaryWatermarkPainter extends CustomPainter {
  final Color color;

  const _SanctuaryWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Two interlaced squares forming 8-point geometric star
    final half = radius * 0.7071;
    final rect1 = Rect.fromCenter(center: center, width: half * 2, height: half * 2);

    canvas.save();
    canvas.drawRect(rect1, paint);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawRect(rect1, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SanctuaryWatermarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
