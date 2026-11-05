import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:sakina_app/features/verse_card_maker/domain/services/verse_card_video_generator.dart';
import 'package:share_plus/share_plus.dart';

/// Helper utility for capturing and exporting the 4K verse card and MP4 video reels,
/// with gallery saving and native social sharing.
abstract final class VerseCardExporter {
  /// Captures the widget at [boundaryKey] as a 3.0x high-resolution PNG file.
  static Future<File?> captureCardImage(GlobalKey boundaryKey) async {
    final boundary = boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;

    if (boundary.debugNeedsPaint) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final pngBytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/sakina_card_$timestamp.png');
    await file.writeAsBytes(pngBytes, flush: true);
    return file;
  }

  /// Saves the rendered card to the photo gallery with native fallback to share.
  static Future<void> saveToGallery({
    required BuildContext context,
    required GlobalKey boundaryKey,
    required VerseCardItem verse,
  }) async {
    try {
      final file = await captureCardImage(boundaryKey);
      if (file == null) throw Exception('Render boundary error');

      try {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putImage(file.path, album: 'سَكِينَة');
        if (context.mounted) {
          AppTopSnackBar.showSuccess(
            context: context,
            message: 'تم حفظ بطاقة الآية بدقة فائقة في ألبوم الصور',
          );
        }
      } catch (_) {
        if (context.mounted) {
          final box = context.findRenderObject() as RenderBox?;
          final originRect = box != null
              ? box.localToGlobal(Offset.zero) & box.size
              : null;
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path, mimeType: 'image/png')],
              sharePositionOrigin: originRect,
              text:
                  '«${verse.ayahText}» [سورة ${verse.surahName} - آية ${verse.ayahNumber}]\nتطبيق سَكِينَة',
            ),
          );
        }
      }
    } catch (e, st) {
      AppLogger.error('Failed to export card image', e, st, 'CARD_MAKER');
      if (context.mounted) {
        AppTopSnackBar.show(
          context: context,
          message: 'تعذر حفظ البطاقة، يرجى المحاولة مرة أخرى',
        );
      }
    }
  }

  /// Compiles, exports, and saves a composite 30s MP4 video reel to gallery.
  static Future<File?> saveVideoReel({
    required BuildContext context,
    required File videoFile,
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
    List<File>? overlayFiles,
    List<double>? ayahDurations,
    GlobalKey? boundaryKey,
    void Function(double progress, String step)? onProgress,
  }) async {
    try {
      final video = await VerseCardVideoGenerator.generateVideo(
        videoFile: videoFile,
        verse: verse,
        reciter: reciter,
        overlayFiles: overlayFiles,
        ayahDurations: ayahDurations,
        boundaryKey: boundaryKey,
        onProgress: onProgress,
      );

      if (video == null) throw Exception('Video generation returned null');

      final saved = await VerseCardVideoGenerator.saveVideoToGallery(video);
      onProgress?.call(1.0, 'اكْتَمَلَ الحِفْظُ فِي أَلْبُومِ سَكِينَة بِنَجَاح! ✨');
      if (context.mounted) {
        if (saved) {
          AppTopSnackBar.showSuccess(
            context: context,
            message: 'تم حفظ مقطع الريلز القرآني (حتى 30ث) في ألبوم سَكِينَة',
          );
        } else {
          await shareVideoReel(
            context: context,
            videoFile: videoFile,
            verse: verse,
            reciter: reciter,
            overlayFiles: overlayFiles,
            ayahDurations: ayahDurations,
            boundaryKey: boundaryKey,
          );
        }
      }
      return video;
    } catch (e, st) {
      AppLogger.error('Failed to export video reel', e, st, 'CARD_MAKER');
      if (context.mounted) {
        AppTopSnackBar.show(
          context: context,
          message: 'تعذر إنتاج الفيديو، يرجى التأكد من مساحة الجهاز وإعادة المحاولة',
        );
      }
      return null;
    }
  }

  /// Generates and opens native share sheet for the composite MP4 video reel.
  static Future<void> shareVideoReel({
    required BuildContext context,
    required File videoFile,
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
    List<File>? overlayFiles,
    List<double>? ayahDurations,
    GlobalKey? boundaryKey,
  }) async {
    try {
      final video = await VerseCardVideoGenerator.generateVideo(
        videoFile: videoFile,
        verse: verse,
        reciter: reciter,
        overlayFiles: overlayFiles,
        ayahDurations: ayahDurations,
        boundaryKey: boundaryKey,
      );
      if (video != null && context.mounted) {
        final box = context.findRenderObject() as RenderBox?;
        final originRect =
            box != null ? box.localToGlobal(Offset.zero) & box.size : null;
        await VerseCardVideoGenerator.shareVideo(
          videoFile: video,
          verse: verse,
          sharePositionOrigin: originRect,
        );
      }
    } catch (e, st) {
      AppLogger.error('Failed to share video reel', e, st, 'CARD_MAKER');
    }
  }

  /// Opens native sharing sheet with the rendered high-definition card image.
  static Future<void> shareCard({
    required BuildContext context,
    required GlobalKey boundaryKey,
    required VerseCardItem verse,
  }) async {
    try {
      final file = await captureCardImage(boundaryKey);
      if (file != null && context.mounted) {
        final box = context.findRenderObject() as RenderBox?;
        final originRect =
            box != null ? box.localToGlobal(Offset.zero) & box.size : null;
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'image/png')],
            sharePositionOrigin: originRect,
            text:
                '«${verse.ayahText}» [سورة ${verse.surahName} - آية ${verse.ayahNumber}]\nتطبيق سَكِينَة',
          ),
        );
      }
    } catch (e, st) {
      AppLogger.error('Failed to share card', e, st, 'CARD_MAKER');
    }
  }

  /// Copies verse quotation and Surah citation to device clipboard.
  static void copyVerseText({
    required BuildContext context,
    required VerseCardItem verse,
  }) {
    final text =
        '«${verse.ayahText}»\n[سورة ${verse.surahName} - الآية ${verse.ayahNumber}]\nتطبيق سَكِينَة';
    Clipboard.setData(ClipboardData(text: text));
    AppTopSnackBar.show(
      context: context,
      message: 'تم نسخ نص الآية وتخريجها إلى الحافظة',
      icon: Iconsax.copy,
      iconColor: context.colors.accentGold,
    );
  }
}
