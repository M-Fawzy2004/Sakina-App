import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_video/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new_video/return_code.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:share_plus/share_plus.dart';

/// Encapsulates composite audio file along with duration of each individual Ayah in seconds.
class RecitationAudioResult {
  final File audioFile;
  final List<double> ayahDurations;

  const RecitationAudioResult({
    required this.audioFile,
    required this.ayahDurations,
  });
}

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

  /// Calculates accurate media duration in seconds for an audio file.
  static Future<double> getAudioDuration(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final mediaInfo = session.getMediaInformation();
      final durationStr = mediaInfo?.getDuration();
      if (durationStr != null) {
        final parsed = double.tryParse(durationStr);
        if (parsed != null && parsed > 0) return parsed;
      }
    } catch (_) {}

    // Fallback estimation for 128kbps EveryAyah MP3 (16,000 bytes/sec)
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final bytes = file.lengthSync();
        return (bytes / 16000.0).clamp(1.5, 30.0);
      }
    } catch (_) {}

    return 5.0;
  }

  /// Downloads recitation MP3 from EveryAyah CDN to a temporary local file.
  /// For multi-verse ranges, automatically downloads each ayah, measures its duration,
  /// and concatenates them into a single seamless sacred recitation audio file.
  static Future<RecitationAudioResult?> downloadRecitationAudio({
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final endAyah = verse.endAyahNumber ?? verse.ayahNumber;
      final compositeAudioPath =
          '${tempDir.path}/recitation_${verse.surahNumber}_${verse.ayahNumber}_${endAyah}_${reciter.id}.mp3';
      final compositeFile = File(compositeAudioPath);

      if (!verse.isRange) {
        if (!await compositeFile.exists()) {
          final audioUrl = EveryAyahAudioUrlBuilder.buildUrl(
            surahNumber: verse.surahNumber,
            ayahNumber: verse.ayahNumber,
            reciterId: reciter.id,
          );
          await _dio.download(audioUrl, compositeAudioPath);
        }
        final dur = await getAudioDuration(compositeAudioPath);
        return RecitationAudioResult(
          audioFile: compositeFile,
          ayahDurations: [dur],
        );
      }

      // Multi-ayah concatenation: download each individual ayah & collect durations
      final List<String> downloadedFiles = [];
      final List<double> durations = [];

      for (int a = verse.ayahNumber; a <= endAyah; a++) {
        final ayahUrl = EveryAyahAudioUrlBuilder.buildUrl(
          surahNumber: verse.surahNumber,
          ayahNumber: a,
          reciterId: reciter.id,
        );
        final singleAyahPath =
            '${tempDir.path}/single_recitation_${verse.surahNumber}_${a}_${reciter.id}.mp3';
        final singleAyahFile = File(singleAyahPath);
        if (!await singleAyahFile.exists()) {
          await _dio.download(ayahUrl, singleAyahPath);
        }
        downloadedFiles.add(singleAyahPath);
        final dur = await getAudioDuration(singleAyahPath);
        durations.add(dur);
      }

      // Concatenate via FFmpeg concat demuxer if not already compiled
      if (!await compositeFile.exists()) {
        final concatListFile = File(
            '${tempDir.path}/concat_list_${DateTime.now().millisecondsSinceEpoch}.txt');
        final concatListContent = downloadedFiles
            .map((p) => "file '${p.replaceAll(r'\', '/')}'")
            .join('\n');
        await concatListFile.writeAsString(concatListContent);

        final concatCommand =
            '-y -f concat -safe 0 -i "${concatListFile.path.replaceAll(r'\', '/')}" -c copy "$compositeAudioPath"';
        final session = await FFmpegKit.execute(concatCommand);
        final returnCode = await session.getReturnCode();

        try {
          if (await concatListFile.exists()) await concatListFile.delete();
        } catch (_) {}

        if (!ReturnCode.isSuccess(returnCode) || !await compositeFile.exists()) {
          // Fallback: Binary stream concatenation for identical MPEG audio frames
          final sink = compositeFile.openWrite();
          for (final p in downloadedFiles) {
            await sink.addStream(File(p).openRead());
          }
          await sink.close();
        }
      }

      if (await compositeFile.exists()) {
        return RecitationAudioResult(
          audioFile: compositeFile,
          ayahDurations: durations,
        );
      }

      return null;
    } catch (e, st) {
      AppLogger.error('Failed to download audio', e, st, 'VIDEO_GENERATOR');
      return null;
    }
  }

  /// Compiles user video, sacred recitation, and typography overlay into a finished MP4 file.
  /// MUTES any original audio in the user video, prevents overlay stretching with aspect-ratio
  /// preservation, and handles smooth sequential transitions between consecutive verses via concat demuxer.
  static Future<File?> generateVideo({
    required File videoFile,
    required VerseCardItem verse,
    required EveryAyahReciter reciter,
    List<File>? overlayFiles,
    List<double>? ayahDurations,
    GlobalKey? boundaryKey,
    void Function(double progress, String step)? onProgress,
  }) async {
    File? concatListFile;
    try {
      onProgress?.call(0.10, 'جَارٍ تَحْمِيلُ التِّلَاوَةِ العَطِرَةِ...');
      final audioResult = await downloadRecitationAudio(
        verse: verse,
        reciter: reciter,
      );

      if (audioResult == null) throw Exception('Audio file unavailable');
      final audioFile = audioResult.audioFile;

      onProgress?.call(0.30, 'جَارٍ تَهْيِئَةُ مَشَاهِدِ الآيَاتِ...');
      // Ensure we have at least one overlay file
      List<File> overlays = overlayFiles ?? [];
      if (overlays.isEmpty && boundaryKey != null) {
        final captured = await captureOverlayPng(boundaryKey);
        if (captured != null) overlays = [captured];
      }

      if (overlays.isEmpty) throw Exception('No overlay files available');

      final durations = (ayahDurations != null && ayahDurations.isNotEmpty)
          ? ayahDurations
          : audioResult.ayahDurations;

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${tempDir.path}/sakina_reel_$timestamp.mp4';

      final videoPath = videoFile.path.replaceAll(r'\', '/');
      final audioPath = audioFile.path.replaceAll(r'\', '/');

      onProgress?.call(0.45, 'جَارٍ مَوْنَتَاجُ الرِّيلْز وَدَمْجُ الفِيدْيُو وَالصَّوْتِ...');

      String inputs = '';
      String filterComplex = '';

      if (overlays.length > 1) {
        // Multi-ayah video: Use rock-solid FFmpeg concat demuxer for seamless image sequence
        concatListFile = File('${tempDir.path}/concat_overlays_$timestamp.txt');
        final concatBuffer = StringBuffer();
        concatBuffer.writeln('ffconcat version 1.0');
        for (int i = 0; i < overlays.length; i++) {
          final p = overlays[i].path.replaceAll(r'\', '/');
          final d = (i < durations.length && durations[i] > 0)
              ? durations[i]
              : 5.0;
          concatBuffer.writeln("file '$p'");
          concatBuffer.writeln('duration ${d.toStringAsFixed(2)}');
        }
        // ffconcat spec requires repeating the last file
        final lastP = overlays.last.path.replaceAll(r'\', '/');
        concatBuffer.writeln("file '$lastP'");
        await concatListFile.writeAsString(concatBuffer.toString());

        final concatPath = concatListFile.path.replaceAll(r'\', '/');
        inputs =
            '-y -stream_loop -1 -i "$videoPath" -f concat -safe 0 -i "$concatPath" -i "$audioPath" ';
        filterComplex =
            '[0:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280[bg];'
            '[1:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2:color=0x00000000,format=rgba[fg];'
            '[bg][fg]overlay=0:0[outv]';
      } else {
        // Single ayah: direct looped image overlay
        final singleOverlayPath = overlays.first.path.replaceAll(r'\', '/');
        inputs =
            '-y -stream_loop -1 -i "$videoPath" -loop 1 -i "$singleOverlayPath" -i "$audioPath" ';
        filterComplex =
            '[0:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280[bg];'
            '[1:v]scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2:color=0x00000000,format=rgba[fg];'
            '[bg][fg]overlay=0:0[outv]';
      }

      bool success = false;

      // Tier 1: High-efficiency H.264 video (input 0 video, input 1 overlays, input 2 audio -> user video audio 100% MUTED)
      final command =
          '$inputs'
          '-filter_complex "$filterComplex" '
          '-map "[outv]" -map 2:a:0 -t 30 -c:v libx264 -preset ultrafast -pix_fmt yuv420p -c:a aac -b:a 192k -shortest "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      success = ReturnCode.isSuccess(returnCode);

      // Tier 2 Fallback: Universal MPEG4 encoding
      if (!success) {
        final fallbackCommand =
            '$inputs'
            '-filter_complex "$filterComplex" '
            '-map "[outv]" -map 2:a:0 -t 30 -c:v mpeg4 -q:v 3 -c:a aac -b:a 192k -shortest "$outputPath"';

        final fallbackSession = await FFmpegKit.execute(fallbackCommand);
        final fallbackReturn = await fallbackSession.getReturnCode();
        success = ReturnCode.isSuccess(fallbackReturn);
      }

      // Tier 3 Fallback: Audio overlay mux on direct stream (user video strictly muted via -map 1:a:0)
      if (!success) {
        final directMuxCommand =
            '-y -i "$videoPath" -i "$audioPath" -map 0:v:0 -map 1:a:0 -t 30 -c:v copy -c:a aac -shortest "$outputPath"';
        final directSession = await FFmpegKit.execute(directMuxCommand);
        final directReturn = await directSession.getReturnCode();
        success = ReturnCode.isSuccess(directReturn);
      }

      onProgress?.call(0.85, 'جَارٍ حِفْظُ المَقْطَعِ فِي أَلْبُومِ سَكِينَة...');

      final outputFile = File(outputPath);
      if (success && await outputFile.exists()) {
        return outputFile;
      }
      return null;
    } catch (e, st) {
      AppLogger.error('Failed to generate video', e, st, 'VIDEO_GENERATOR');
      return null;
    } finally {
      try {
        if (concatListFile != null && await concatListFile.exists()) {
          await concatListFile.delete();
        }
      } catch (_) {}
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

