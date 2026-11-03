import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:share_plus/share_plus.dart';

/// Helper utility to render and export the customized Quranic hope card as a high-resolution PNG image.
abstract final class InabaHopeCardExporter {
  static Future<bool> exportAndShare({
    required BuildContext context,
    required GlobalKey boundaryKey,
    required String verseSource,
  }) async {
    // Capture origin before any asynchronous gap for iPad/Mac share popover
    final box = context.findRenderObject() as RenderBox?;
    final originRect =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    try {
      HapticFeedback.mediumImpact();

      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        return false;
      }

      // Render at 3.0x pixel ratio for high-definition clarity
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return false;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/sakina_hope_$timestamp.png');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: '«جرعة أمل وتثبيت من تطبيق سَكِينَة» • $verseSource',
          sharePositionOrigin: originRect,
        ),
      );

      return true;
    } catch (_) {
      if (context.mounted) {
        final colors = context.colors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'تعذر تجهيز الصورة، يرجى المحاولة مرة ثانية',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: colors.cardSurface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }
}
