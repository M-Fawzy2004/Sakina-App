import 'package:sakina_app/core/errors/exceptions.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/surah_metadata_utils.dart';
import 'package:sakina_app/features/audio_reciters/data/models/recitation_track_model.dart';
import 'package:sakina_app/features/audio_reciters/data/models/reciter_model.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/reciter_entity.dart';

abstract interface class AudioRecitersLocalDataSource {
  Future<List<ReciterModel>> getReciters({String? category, String? query});
  Future<List<ReciterModel>> getFeaturedReciters();
  Future<ReciterModel> getFeaturedReciter();
  Future<List<RecitationTrackModel>> getReciterTracks(int reciterId);
  Future<RecitationTrackModel> getTrackById(int trackId);
}

class AudioRecitersLocalDataSourceImpl implements AudioRecitersLocalDataSource {
  static final List<ReciterModel> _reciters = ReciterEntity.topReciters
      .map((entity) => ReciterModel.fromEntity(entity))
      .toList();

  @override
  Future<List<ReciterModel>> getReciters({String? category, String? query}) async {
    try {
      var result = List<ReciterModel>.from(_reciters);

      if (category != null && category.isNotEmpty && category != 'الكل') {
        result = result.where((r) => r.categories.contains(category)).toList();
      }

      if (query != null && query.trim().isNotEmpty) {
        final cleanQuery = query.trim().toLowerCase();
        result = result.where((r) {
          final arabicMatch = r.nameArabic.toLowerCase().contains(cleanQuery);
          final englishMatch = r.englishName.toLowerCase().contains(cleanQuery);
          final styleMatch = r.revelationStyle.toLowerCase().contains(cleanQuery);
          return arabicMatch || englishMatch || styleMatch;
        }).toList();
      }

      return result;
    } catch (e) {
      AppLogger.error('Failed to getReciters', e);
      throw const CacheException(message: 'تعذر تحميل قائمة القراء، يرجى المحاولة لاحقاً');
    }
  }

  @override
  Future<List<ReciterModel>> getFeaturedReciters() async {
    try {
      final featuredList = _reciters.where((r) => r.isFeatured).toList();
      return featuredList.isNotEmpty ? featuredList : _reciters.take(4).toList();
    } catch (e) {
      AppLogger.error('Failed to getFeaturedReciters', e);
      throw const CacheException(message: 'تعذر استرجاع القراء المميزين');
    }
  }

  @override
  Future<ReciterModel> getFeaturedReciter() async {
    try {
      final featured = _reciters.firstWhere(
        (r) => r.isFeatured,
        orElse: () => _reciters.first,
      );
      return featured;
    } catch (e) {
      AppLogger.error('Failed to getFeaturedReciter', e);
      throw const CacheException(message: 'تعذر استرجاع القارئ المختار');
    }
  }

  @override
  Future<List<RecitationTrackModel>> getReciterTracks(int reciterId) async {
    try {
      final reciter = _reciters.firstWhere(
        (r) => r.id == reciterId,
        orElse: () => _reciters.first,
      );

      return List.generate(114, (index) {
        final surahId = index + 1;
        final padded = surahId.toString().padLeft(3, '0');
        final surahName = SurahMetadataUtils.getCalligraphicSurahName(
          surahId,
          'سورة $surahId',
        );

        return RecitationTrackModel(
          id: reciter.id * 1000 + surahId,
          reciterId: reciter.id,
          reciterName: reciter.nameArabic,
          surahId: surahId,
          surahNameArabic: surahName,
          styleDescription: '${reciter.nameArabic} • ${reciter.revelationStyle}',
          audioUrl: '${reciter.serverUrl}$padded.mp3',
          duration: const Duration(minutes: 0, seconds: 0),
          riwayah: reciter.riwayah,
        );
      });
    } catch (e) {
      AppLogger.error('Failed to getReciterTracks for $reciterId', e);
      throw const CacheException(message: 'تعذر استرجاع تلاوات القارئ، يرجى المحاولة مجدداً');
    }
  }

  @override
  Future<RecitationTrackModel> getTrackById(int trackId) async {
    try {
      final reciterId = trackId ~/ 1000;
      final rawSurahId = trackId % 1000;
      final validSurahId = (rawSurahId >= 1 && rawSurahId <= 114) ? rawSurahId : 1;

      final reciter = _reciters.firstWhere(
        (r) => r.id == reciterId,
        orElse: () => _reciters.first,
      );
      final padded = validSurahId.toString().padLeft(3, '0');
      final surahName = SurahMetadataUtils.getCalligraphicSurahName(
        validSurahId,
        'سورة $validSurahId',
      );

      return RecitationTrackModel(
        id: trackId,
        reciterId: reciter.id,
        reciterName: reciter.nameArabic,
        surahId: validSurahId,
        surahNameArabic: surahName,
        styleDescription: '${reciter.nameArabic} • ${reciter.revelationStyle}',
        audioUrl: '${reciter.serverUrl}$padded.mp3',
        duration: const Duration(minutes: 0, seconds: 0),
        riwayah: reciter.riwayah,
      );
    } catch (e) {
      AppLogger.error('Failed to getTrackById for $trackId', e);
      throw const CacheException(message: 'تعذر استرجاع بيانات المقطع الصوتي');
    }
  }
}
