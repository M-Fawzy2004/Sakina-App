import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:share_plus/share_plus.dart';

/// Helper utility to render and save the customized Quranic hope card directly to the
/// device photo gallery on iOS & Android, with resilient native sharing fallback.
abstract final class InabaHopeCardExporter {
  /// Captures the widget at [boundaryKey] as a high-resolution PNG file.
  static Future<File?> _captureCardImage(GlobalKey boundaryKey) async {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return null;

    // Await boundary frame paint if still undergoing raster layout
    if (boundary.debugNeedsPaint) {
      await Future<void>.delayed(const Duration(milliseconds: 30));
    }

    // Render at 3.0x pixel ratio for crystal-clear high-definition export
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) return null;

    final pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/sakina_hope_$timestamp.png');
    await file.writeAsBytes(pngBytes, flush: true);
    return file;
  }

  /// Opens native share dialog as a resilient fallback for saving/exporting.
  static Future<void> _fallbackToShare(
    BuildContext context,
    File file,
    String feedbackMessage,
  ) async {
    final box = context.findRenderObject() as RenderBox?;
    final originRect = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    AppTopSnackBar.show(
      context: context,
      icon: Iconsax.gallery_export,
      message: feedbackMessage,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: '«جرعة أمل وتثبيت من تطبيق سَكِينَة» 🌿',
        sharePositionOrigin: originRect,
      ),
    );
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

      bool directSaveSucceeded = false;

      try {
        // Request access if not yet granted
        bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          hasAccess = await Gal.requestAccess();
        }

        if (hasAccess) {
          await Gal.putImage(file.path);
          directSaveSucceeded = true;
        }
      } on GalException catch (e) {
        AppLogger.debug(
          'GalException while saving image: $e',
          'INABA_EXPORTER',
        );
      } catch (e, stack) {
        AppLogger.debug(
          'Direct save failed, using native export: $e\n$stack',
          'INABA_EXPORTER',
        );
      }

      if (directSaveSucceeded) {
        if (context.mounted) {
          AppTopSnackBar.showSuccess(
            context: context,
            icon: Iconsax.gallery_tick,
            message: 'تم حفظ الصورة في ألبوم الصور بنجاح 🌿',
          );
        }
        return true;
      }

      // If direct gallery saving encountered an OS permission or driver limit,
      // fall back gracefully to the system share sheet (which allows saving to Photos/Files).
      if (context.mounted) {
        await _fallbackToShare(
          context,
          file,
          'تم تجهيز الصورة، اختر «حفظ الصورة» من القائمة 🌿',
        );
      }
      return true;
    } on MissingPluginException {
      if (context.mounted) {
        AppTopSnackBar.show(
          context: context,
          icon: Iconsax.refresh,
          message: 'يرجى إيقاف التطبيق وإعادة تشغيله (Full Restart) لتفعيل الحفظ 🔄',
        );
      }
      return false;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to export card image',
        e,
        stack,
        'INABA_EXPORTER',
      );
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
    final originRect = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

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
