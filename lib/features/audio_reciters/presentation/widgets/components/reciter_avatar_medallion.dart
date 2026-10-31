import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Ornate circular medallion avatar with concentric metallic gold borders.
/// If offline or image is unavailable, renders a magnificent illuminated Islamic rosette medallion.
class ReciterAvatarMedallion extends StatelessWidget {
  final String? photoUrl;
  final String nameArabic;
  final double size;
  final bool isGlowing;

  const ReciterAvatarMedallion({
    super.key,
    this.photoUrl,
    required this.nameArabic,
    this.size = 54,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.r;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isGlowing ? AppColors.champagneGold : AppColors.goldBorderStroke,
          width: isGlowing ? 2.r : 1.5.r,
        ),
        gradient: const RadialGradient(
          colors: [
            AppColors.carbonSlate,
            AppColors.obsidianCore,
          ],
        ),
      ),
      padding: EdgeInsets.all(3.r),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.goldBorderStroke,
            width: 1.r,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? Image.network(
                photoUrl!,
                headers: const {'User-Agent': 'Sakina/1.0 (IslamicQuranSanctuary)'},
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _ReciterFallbackAvatar(nameArabic: nameArabic);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _ReciterFallbackAvatar(nameArabic: nameArabic);
                },
              )
            : _ReciterFallbackAvatar(nameArabic: nameArabic),
      ),
    );
  }
}

/// Royal illuminated Islamic rosette medallion with Arabic calligraphy.
class _ReciterFallbackAvatar extends StatelessWidget {
  final String nameArabic;

  const _ReciterFallbackAvatar({required this.nameArabic});

  @override
  Widget build(BuildContext context) {
    // Extract honorific title/initials (e.g. "عبد الباسط" or "المنشاوي")
    final parts = nameArabic.trim().split(' ');
    final displayName = parts.length > 2 ? parts[parts.length - 2] : parts.last;
    final initial = displayName.isNotEmpty ? displayName.characters.first : 'ق';

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            AppColors.deepSanctuary,
            AppColors.carbonSlate,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Geometric 8-pointed star rosette watermark
          CustomPaint(
            size: const Size.square(double.infinity),
            painter: _IslamicRosettePainter(),
          ),

          // Central Monogram in authentic Amiri Quranic Calligraphy
          Text(
            initial,
            style: GoogleFonts.amiri(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.paleRadiance,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _IslamicRosettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final paint = Paint()
      ..color = AppColors.champagneGold.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw interlocking rotated squares (octagram)
    for (int i = 0; i < 2; i++) {
      final angle = i * math.pi / 4;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: radius * 1.4, height: radius * 1.4),
        paint,
      );
      canvas.restore();
    }

    // Outer subtle boundary ring
    canvas.drawCircle(center, radius * 1.05, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
