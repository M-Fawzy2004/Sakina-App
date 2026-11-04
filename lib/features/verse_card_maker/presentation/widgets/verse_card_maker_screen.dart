import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_actions_row.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_background_selector.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_display.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_duration_matcher_chip.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_exporter.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_playback_bar.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_top_bar.dart';
import 'package:video_player/video_player.dart';

/// Al-Maladh Flagship "Verse Card Studio" (صَانِعُ بِطَاقَاتِ الآيَاتِ).
/// Creates luxury 4K cards and Reels/TikTok videos (up to 30s) with recitation audio,
/// duration synchronization, and 10 preset celestial backgrounds without shadows.
class VerseCardMakerScreen extends StatefulWidget {
  const VerseCardMakerScreen({super.key});

  @override
  State<VerseCardMakerScreen> createState() => _VerseCardMakerScreenState();
}

class _VerseCardMakerScreenState extends State<VerseCardMakerScreen> {
  final GlobalKey _cardKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  VideoPlayerController? _videoController;
  int _currentVerseIndex = 0;
  String _selectedPresetAsset = 'assets/images/background_1.jpg';
  File? _customImageFile;
  File? _customVideoFile;

  EveryAyahReciter _selectedReciter = EveryAyahReciter.defaultReciter;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadUserSavedReciter();
    _initAudioListeners();
  }

  void _loadUserSavedReciter() {
    try {
      if (sl.isRegistered<PreferencesService>()) {
        final prefs = sl<PreferencesService>();
        final savedReciterId =
            prefs.getString(SettingsPersistenceManager.keyReciterId);
        if (savedReciterId != null) {
          final found = EveryAyahReciter.availableReciters.firstWhere(
            (r) => r.id == savedReciterId,
            orElse: () => EveryAyahReciter.defaultReciter,
          );
          _selectedReciter = found;
        }
      }
    } catch (_) {}
  }

  void _initAudioListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      final isPlaying =
          state.playing && state.processingState != ProcessingState.completed;
      final isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;

      setState(() {
        _isPlaying = isPlaying;
        _isLoadingAudio = isLoading;
      });

      if (state.processingState == ProcessingState.completed) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  VerseCardItem get _currentVerse =>
      VerseCardItem.curatedVerses[_currentVerseIndex];

  int get _videoDurationSeconds =>
      _videoController?.value.duration.inSeconds ?? 0;

  Future<void> _toggleAudioPlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    try {
      final url = EveryAyahAudioUrlBuilder.buildUrl(
        surahNumber: _currentVerse.surahNumber,
        ayahNumber: _currentVerse.ayahNumber,
        reciterId: _selectedReciter.id,
      );

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e, st) {
      AppLogger.error('Audio playback error', e, st, 'CARD_MAKER');
      if (mounted) {
        AppTopSnackBar.show(
          context: context,
          message: 'تعذر تشغيل التلاوة، يرجى التحقق من الاتصال بالإنترنت',
        );
      }
    }
  }

  void _nextVerse() {
    _audioPlayer.stop();
    setState(() {
      _currentVerseIndex =
          (_currentVerseIndex + 1) % VerseCardItem.curatedVerses.length;
    });
  }

  void _previousVerse() {
    _audioPlayer.stop();
    setState(() {
      _currentVerseIndex = (_currentVerseIndex - 1 +
              VerseCardItem.curatedVerses.length) %
          VerseCardItem.curatedVerses.length;
    });
  }

  void _handleRandomVerse() {
    _audioPlayer.stop();
    final random = Random();
    int nextIndex;
    do {
      nextIndex = random.nextInt(VerseCardItem.curatedVerses.length);
    } while (nextIndex == _currentVerseIndex &&
        VerseCardItem.curatedVerses.length > 1);

    setState(() => _currentVerseIndex = nextIndex);
    AppTopSnackBar.show(
      context: context,
      message: 'نفحة قرآنية مباركة: سورة ${_currentVerse.surahName}',
    );
  }

  void _autoMatchVerseToVideo() {
    if (_videoDurationSeconds <= 0) return;
    final cappedDuration =
        _videoDurationSeconds > 30 ? 30 : _videoDurationSeconds;
    final bestIndex =
        VerseCardItem.findBestMatchingIndex(cappedDuration);
    _audioPlayer.stop();
    setState(() => _currentVerseIndex = bestIndex);
    AppTopSnackBar.showSuccess(
      context: context,
      message:
          'تم توفيق الآية مع مدة الفيديو (30ث كحد أقصى): سورة ${_currentVerse.surahName}',
    );
  }

  Future<void> _pickCustomImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );
      if (image != null) {
        _videoController?.pause();
        _videoController?.dispose();
        setState(() {
          _videoController = null;
          _customVideoFile = null;
          _customImageFile = File(image.path);
        });
      }
    } catch (e, st) {
      AppLogger.error('Failed to pick image', e, st, 'CARD_MAKER');
    }
  }

  Future<void> _pickCustomVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );
      if (video != null) {
        _videoController?.dispose();
        final controller = VideoPlayerController.file(File(video.path));
        await controller.initialize();
        await controller.setLooping(true);
        await controller.setVolume(0.0);
        await controller.play();

        if (mounted) {
          final dur = controller.value.duration.inSeconds;
          if (dur > 30) {
            AppTopSnackBar.show(
              context: context,
              message:
                  'تنبيه: مدة الفيديو $dur ثانية، وسيتم اقتطاعه حتى 30 ثانية لمطابقة الريلز',
            );
          }
          setState(() {
            _customImageFile = null;
            _customVideoFile = File(video.path);
            _videoController = controller;
          });
          final matchIndex =
              VerseCardItem.findBestMatchingIndex(dur > 30 ? 30 : dur);
          setState(() => _currentVerseIndex = matchIndex);
        }
      }
    } catch (e, st) {
      AppLogger.error('Failed to pick video', e, st, 'CARD_MAKER');
    }
  }

  void _selectPresetAsset(String asset) {
    _videoController?.pause();
    _videoController?.dispose();
    setState(() {
      _videoController = null;
      _customVideoFile = null;
      _customImageFile = null;
      _selectedPresetAsset = asset;
    });
  }

  Future<void> _handleSavePrimary() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    if (_customVideoFile != null) {
      await VerseCardExporter.saveVideoReel(
        context: context,
        videoFile: _customVideoFile!,
        verse: _currentVerse,
        reciter: _selectedReciter,
        boundaryKey: _cardKey,
      );
    } else {
      await VerseCardExporter.saveToGallery(
        context: context,
        boundaryKey: _cardKey,
        verse: _currentVerse,
      );
    }

    if (mounted) setState(() => _isExporting = false);
  }

  Future<void> _handleSaveImageSecondary() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    await VerseCardExporter.saveToGallery(
      context: context,
      boundaryKey: _cardKey,
      verse: _currentVerse,
    );
    if (mounted) setState(() => _isExporting = false);
  }

  Future<void> _handleShareCard() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    if (_customVideoFile != null) {
      await VerseCardExporter.shareVideoReel(
        context: context,
        videoFile: _customVideoFile!,
        verse: _currentVerse,
        reciter: _selectedReciter,
        boundaryKey: _cardKey,
      );
    } else {
      await VerseCardExporter.shareCard(
        context: context,
        boundaryKey: _cardKey,
        verse: _currentVerse,
      );
    }

    if (mounted) setState(() => _isExporting = false);
  }

  void _handleCopyText() {
    VerseCardExporter.copyVerseText(
      context: context,
      verse: _currentVerse,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isVideoMode = _customVideoFile != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              VerseCardTopBar(
                onBack: () => Navigator.of(context).pop(),
                onRandomAyah: _handleRandomVerse,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomPadding + 24.h),
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AspectRatio(
                          aspectRatio: 0.94,
                          child: VerseCardDisplay(
                            cardKey: _cardKey,
                            verse: _currentVerse,
                            presetAsset: _customImageFile == null &&
                                    _customVideoFile == null
                                ? _selectedPresetAsset
                                : null,
                            customImageFile: _customImageFile,
                            videoController: _videoController,
                            reciterName: _selectedReciter.nameArabic,
                            isPlayingRecitation: _isPlaying,
                          ),
                        ),
                      ),
                      if (isVideoMode && _videoDurationSeconds > 0) ...[
                        SizedBox(height: 8.h),
                        VerseCardDurationMatcherChip(
                          videoDurationSeconds: _videoDurationSeconds,
                          currentVerse: _currentVerse,
                          onAutoMatchVerse: _autoMatchVerseToVideo,
                        ),
                      ],
                      SizedBox(height: 14.h),
                      VerseCardPlaybackBar(
                        selectedReciter: _selectedReciter,
                        isPlaying: _isPlaying,
                        isLoadingAudio: _isLoadingAudio,
                        onTogglePlay: _toggleAudioPlay,
                        onNextAyah: _nextVerse,
                        onPreviousAyah: _previousVerse,
                        onReciterChanged: (reciter) {
                          setState(() => _selectedReciter = reciter);
                          if (_isPlaying) _toggleAudioPlay();
                        },
                      ),
                      SizedBox(height: 16.h),
                      VerseCardBackgroundSelector(
                        selectedPresetAsset: _selectedPresetAsset,
                        hasCustomImage: _customImageFile != null,
                        hasCustomVideo: _customVideoFile != null,
                        onSelectPreset: _selectPresetAsset,
                        onPickCustomImage: _pickCustomImage,
                        onPickCustomVideo: _pickCustomVideo,
                      ),
                      SizedBox(height: 20.h),
                      VerseCardActionsRow(
                        isExporting: _isExporting,
                        isVideoMode: isVideoMode,
                        onSavePrimary: _handleSavePrimary,
                        onSaveImageSecondary:
                            isVideoMode ? _handleSaveImageSecondary : null,
                        onShareCard: _handleShareCard,
                        onCopyText: _handleCopyText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
