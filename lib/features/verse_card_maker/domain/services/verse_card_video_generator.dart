import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_video/return_code.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:share_plus/share_plus.dart';

/// Service responsible for rendering and exporting TikTok/Reels-style Quranic videos
/// by muxing background video with sacred recitation audio and card overlay typography.
abstract final class VerseCardVideoGenerator {
  static final Dio _dio = Dio();

  /// Captures the specified widget boundary as a transparent high-resolution PNG overlay.
  static Future<File?> captureOverlayPng(GlobalKey boundaryKey) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      if (boundary.debugNeedsPaint) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/verse_overlay_$timestamp.png');
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
      return file;
    } catch (e, st) {
      AppLogger.error('Failed to capture overlay PNG', e, st, 'VIDEO_GENERATOR');
      return null;
    }
  }

  /// Downloads recitation MP3 from EveryAyah CDN to a temporary local file.
  static Future<File?> downloadRecitationAudio({
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
  }) async {
    try {
      final audioUrl = EveryAyahAudioUrlBuilder.buildUrl(
        surahNumber: verse.surahNumber,
        ayahNumber: verse.ayahNumber,
        reciterId: reciter.id,
      );

      final tempDir = await getTemporaryDirectory();
      final audioPath =
          '${tempDir.path}/recitation_${verse.surahNumber}_${verse.ayahNumber}_${reciter.id}.mp3';
      final file = File(audioPath);

      if (await file.exists()) {
        return file;
      }

      await _dio.download(audioUrl, audioPath);
      return file;
    } catch (e, st) {
      AppLogger.error('Failed to download audio', e, st, 'VIDEO_GENERATOR');
      return null;
    }
  }

  /// Compiles user video, sacred recitation, and typography overlay into a finished MP4 file.
  static Future<File?> generateVideo({
    required File videoFile,
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
    required GlobalKey boundaryKey,
  }) async {
    try {
      final overlayFile = await captureOverlayPng(boundaryKey);
      final audioFile = await downloadRecitationAudio(
        verse: verse,
        reciter: reciter,
      );

      if (audioFile == null) throw Exception('Audio file unavailable');

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${tempDir.path}/sakina_reel_$timestamp.mp4';

      final videoPath = videoFile.path;
      final audioPath = audioFile.path;

      bool success = false;

      // Tier 1: High-efficiency H.264 video with composite overlay (max 30 seconds)
      if (overlayFile != null) {
        final overlayPath = overlayFile.path;
        final command =
            '-y -stream_loop -1 -i "$videoPath" -loop 1 -i "$overlayPath" -i "$audioPath" '
            '-filter_complex "[0:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280[bg];[1:v]scale=720:1280[fg];[bg][fg]overlay=0:0[outv]" '
            '-map "[outv]" -map 2:a -t 30 -c:v libx264 -preset ultrafast -pix_fmt yuv420p -c:a aac -b:a 192k -shortest "$outputPath"';

        final session = await FFmpegKit.execute(command);
        final returnCode = await session.getReturnCode();
        success = ReturnCode.isSuccess(returnCode);
      }

      // Tier 2 Fallback: Universal MPEG4 encoding with composite overlay (max 30 seconds)
      if (!success && overlayFile != null) {
        final overlayPath = overlayFile.path;
        final fallbackCommand =
            '-y -stream_loop -1 -i "$videoPath" -loop 1 -i "$overlayPath" -i "$audioPath" '
            '-filter_complex "[0:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280[bg];[1:v]scale=720:1280[fg];[bg][fg]overlay=0:0[outv]" '
            '-map "[outv]" -map 2:a -t 30 -c:v mpeg4 -q:v 3 -c:a aac -b:a 192k -shortest "$outputPath"';

        final session = await FFmpegKit.execute(fallbackCommand);
        final returnCode = await session.getReturnCode();
        success = ReturnCode.isSuccess(returnCode);
      }

      // Tier 3 Fallback: Audio overlay mux on direct stream (max 30 seconds)
      if (!success) {
        final directMuxCommand =
            '-y -i "$videoPath" -i "$audioPath" -map 0:v:0 -map 1:a:0 -t 30 -c:v copy -c:a aac -shortest "$outputPath"';
        final session = await FFmpegKit.execute(directMuxCommand);
        final returnCode = await session.getReturnCode();
        success = ReturnCode.isSuccess(returnCode);
      }

      final outputFile = File(outputPath);
      if (success && await outputFile.exists()) {
        return outputFile;
      }
      return null;
    } catch (e, st) {
      AppLogger.error('Failed to generate video', e, st, 'VIDEO_GENERATOR');
      return null;
    }
  }

  /// Saves generated video to user's gallery in the "سَكِينَة" album.
  static Future<bool> saveVideoToGallery(File videoFile) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) await Gal.requestAccess();
      await Gal.putVideo(videoFile.path, album: 'سَكِينَة');
      return true;
    } catch (e, st) {
      AppLogger.error('Failed to save video to gallery', e, st, 'VIDEO_GENERATOR');
      return false;
    }
  }

  /// Shares generated video through native operating system sharesheet.
  static Future<void> shareVideo({
    required File videoFile,
    required VerseCardItem verse,
    Rect? sharePositionOrigin,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(videoFile.path, mimeType: 'video/mp4')],
          sharePositionOrigin: sharePositionOrigin,
          text:
              '«${verse.ayahText}» [سورة ${verse.surahName} - آية ${verse.ayahNumber}]\nتطبيق سَكِينَة',
        ),
      );
    } catch (e, st) {
      AppLogger.error('Failed to share video', e, st, 'VIDEO_GENERATOR');
    }
  }
}

