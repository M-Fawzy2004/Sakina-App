import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:share_plus/share_plus.dart';

/// Helper utility to render and save the customized Quranic hope card directly to the
/// device photo gallery on iOS & Android, and optionally share it.
abstract final class InabaHopeCardExporter {
  /// Captures the widget at [boundaryKey] as a high-resolution PNG file.
  static Future<File?> _captureCardImage(GlobalKey boundaryKey) async {
    final boundary = boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;

    // Render at 3.0x pixel ratio for crystal-clear high-definition export
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/sakina_hope_$timestamp.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }

  /// Saves the customized hope card directly into the user's Gallery / Photos app (iOS & Android).
  static Future<bool> saveToGallery({
    required BuildContext context,
    required GlobalKey boundaryKey,
  }) async {
    try {
      HapticFeedback.mediumImpact();

      final file = await _captureCardImage(boundaryKey);
      if (file == null) {
        if (context.mounted) {
          AppTopSnackBar.showError(
            context: context,
            message: 'تعذر معالجة صورة البطاقة، حاول مجدداً',
          );
        }
        return false;
      }

      // Save directly to the device's native photo library
      await Gal.putImage(file.path);

      if (context.mounted) {
        AppTopSnackBar.showSuccess(
          context: context,
          icon: Iconsax.gallery_tick,
          message: 'تم حفظ الصورة في ألبوم الصور بنجاح 🌿',
        );
      }
      return true;
    } on GalException catch (e) {
      if (context.mounted) {
        if (e.type == GalExceptionType.accessDenied) {
          AppTopSnackBar.showError(
            context: context,
            message: 'يرجى السماح بالوصول للصور من إعدادات الهاتف لحفظها',
          );
        } else {
          AppTopSnackBar.showError(
            context: context,
            message: 'تعذر حفظ الصورة في المعرض، حاول مجدداً',
          );
        }
      }
      return false;
    } catch (_) {
      if (context.mounted) {
        AppTopSnackBar.showError(
          context: context,
          message: 'حدث خطأ أثناء حفظ الصورة، حاول مجدداً',
        );
      }
      return false;
    }
  }

  /// Opens the native system share sheet to share the customized card image.
  static Future<bool> shareCard({
    required BuildContext context,
    required GlobalKey boundaryKey,
    required String verseSource,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    final originRect =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    try {
      HapticFeedback.mediumImpact();

      final file = await _captureCardImage(boundaryKey);
      if (file == null) return false;

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
        AppTopSnackBar.showError(
          context: context,
          message: 'تعذر مشاركة الصورة حالياً',
        );
      }
      return false;
    }
  }
}
