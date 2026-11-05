import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/services/storage/preferences_service.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/services/everyayah_audio_url_builder.dart';
import 'package:sakina_app/features/settings/domain/services/settings_persistence_manager.dart';
import 'package:sakina_app/features/verse_card_maker/domain/entities/verse_card_item.dart';
import 'package:sakina_app/features/verse_card_maker/domain/services/verse_card_video_generator.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_actions_row.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_ayah_picker_sheet.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_background_selector.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_display.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_duration_matcher_chip.dart';
import 'package:sakina_app/features/verse_card_maker/presentation/widgets/components/verse_card_export_dialog.dart';
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
  final GlobalKey _overlayKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  VideoPlayerController? _videoController;
  int _currentVerseIndex = 0;
  int _currentAyahDisplayIndex = 0;
  VerseCardItem? _customSelectedVerse;
  String _selectedPresetAsset = 'assets/images/background_1.jpg';
  File? _customImageFile;
  File? _customVideoFile;

  bool _isStudioVideoMode = false;
  EveryAyahReciter _selectedReciter = EveryAyahReciter.defaultReciter;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  bool _isExporting = false;

  bool get isVideoMode => _isStudioVideoMode || _customVideoFile != null;

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
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          _currentAyahDisplayIndex = index;
        });
      }
    });

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
        setState(() {
          _isPlaying = false;
          _currentAyahDisplayIndex = 0;
        });
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
      _customSelectedVerse ?? VerseCardItem.curatedVerses[_currentVerseIndex];

  int get _videoDurationSeconds =>
      _videoController?.value.duration.inSeconds ?? 0;

  void _handleModeChanged(bool isVideo) {
    HapticService.selectionClick();
    _audioPlayer.stop();
    setState(() {
      _isStudioVideoMode = isVideo;
      _currentAyahDisplayIndex = 0;
      if (!isVideo) {
        _videoController?.pause();
        _videoController?.dispose();
        _videoController = null;
        _customVideoFile = null;
      }
    });
  }

  void _openAyahPicker() {
    _audioPlayer.stop();
    setState(() => _currentAyahDisplayIndex = 0);
    VerseCardAyahPickerSheet.show(
      context: context,
      isVideoMode: isVideoMode,
      videoDurationSeconds: _videoDurationSeconds,
      onVerseSelected: (item) {
        setState(() {
          _customSelectedVerse = item;
          _currentAyahDisplayIndex = 0;
        });
        AppTopSnackBar.showSuccess(
          context: context,
          message: item.isRange
              ? 'تم اختيار الآيات (${item.ayahNumber}-${item.endAyahNumber}) من سورة ${item.surahName}'
              : 'تم اختيار الآية ${item.ayahNumber} من سورة ${item.surahName}',
        );
      },
    );
  }

  Future<void> _toggleAudioPlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      return;
    }

    try {
      setState(() => _isLoadingAudio = true);

      if (_currentVerse.isRange) {
        final sources = [
          for (int a = _currentVerse.ayahNumber;
              a <= _currentVerse.endAyahNumber!;
              a++)
            AudioSource.uri(
              Uri.parse(
                EveryAyahAudioUrlBuilder.buildUrl(
                  surahNumber: _currentVerse.surahNumber,
                  ayahNumber: a,
                  reciterId: _selectedReciter.id,
                ),
              ),
            ),
        ];
        await _audioPlayer.setAudioSources(sources);
      } else {
        final url = EveryAyahAudioUrlBuilder.buildUrl(
          surahNumber: _currentVerse.surahNumber,
          ayahNumber: _currentVerse.ayahNumber,
          reciterId: _selectedReciter.id,
        );
        await _audioPlayer.setUrl(url);
      }

      await _audioPlayer.play();
    } catch (e, st) {
      AppLogger.error('Audio playback error', e, st, 'CARD_MAKER');
      if (mounted) {
        setState(() => _isLoadingAudio = false);
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
      _customSelectedVerse = null;
      _currentAyahDisplayIndex = 0;
      _currentVerseIndex =
          (_currentVerseIndex + 1) % VerseCardItem.curatedVerses.length;
    });
  }

  void _previousVerse() {
    _audioPlayer.stop();
    setState(() {
      _customSelectedVerse = null;
      _currentAyahDisplayIndex = 0;
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

    setState(() {
      _customSelectedVerse = null;
      _currentAyahDisplayIndex = 0;
      _currentVerseIndex = nextIndex;
    });
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
    setState(() {
      _customSelectedVerse = null;
      _currentAyahDisplayIndex = 0;
      _currentVerseIndex = bestIndex;
    });
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
          _isStudioVideoMode = false;
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
            _isStudioVideoMode = true;
            _videoController = controller;
          });
          final matchIndex =
              VerseCardItem.findBestMatchingIndex(dur > 30 ? 30 : dur);
          setState(() => _currentVerseIndex = matchIndex);
          _openAyahPicker();
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
      _isStudioVideoMode = false;
      _selectedPresetAsset = asset;
    });
  }

  Future<void> _handleSavePrimary() async {
    if (_isExporting) return;

    if (isVideoMode) {
      if (_customVideoFile == null) {
        await _pickCustomVideo();
        return;
      }

      File? exportedVideoFile;

      await VerseCardExportDialog.show(
        context: context,
        onShare: () {
          if (exportedVideoFile != null) {
            VerseCardExporter.shareVideoReel(
              context: context,
              videoFile: exportedVideoFile!,
              verse: _currentVerse,
              reciter: _selectedReciter,
            );
          }
        },
        exportTask: (updateProgress) async {
          updateProgress(0.10, 'جَارٍ تَحْمِيلُ التِّلَاوَةِ العَطِرَةِ لِلآيَاتِ...');
          final audioResult =
              await VerseCardVideoGenerator.downloadRecitationAudio(
            verse: _currentVerse,
            reciter: _selectedReciter,
          );

          final ayahCount = _currentVerse.versesCount;
          final overlayFiles = <File>[];

          updateProgress(0.25, 'جَارٍ تَجْهِيزُ مَشَاهِدِ وَخُطُوطِ الآيَاتِ بدقة 4K...');
          setState(() => _isExporting = true);

          try {
            for (int i = 0; i < ayahCount; i++) {
              if (mounted) {
                setState(() => _currentAyahDisplayIndex = i);
              }
              await WidgetsBinding.instance.endOfFrame;
              await Future<void>.delayed(const Duration(milliseconds: 65));
              final overlay =
                  await VerseCardVideoGenerator.captureOverlayPng(_overlayKey);
              if (overlay != null) {
                overlayFiles.add(overlay);
              }
            }
          } finally {
            if (mounted) {
              setState(() {
                _isExporting = false;
                _currentAyahDisplayIndex = 0;
              });
            }
          }

          updateProgress(0.45, 'جَارٍ مَوْنَتَاجُ الرِّيلْز وَدَمْجُ الفِيدْيُو وَالصَّوْتِ...');
          if (!mounted) return;
          final video = await VerseCardExporter.saveVideoReel(
            context: context,
            videoFile: _customVideoFile!,
            verse: _currentVerse,
            reciter: _selectedReciter,
            overlayFiles: overlayFiles,
            ayahDurations: audioResult?.ayahDurations,
            onProgress: (p, step) {
              updateProgress(p, step);
            },
          );

          exportedVideoFile = video;
          if (video == null) {
            throw Exception('Video export failed');
          }
        },
      );
    } else {
      setState(() => _isExporting = true);
      try {
        await VerseCardExporter.saveToGallery(
          context: context,
          boundaryKey: _cardKey,
          verse: _currentVerse,
        );
      } finally {
        if (mounted) setState(() => _isExporting = false);
      }
    }
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

    if (isVideoMode && _customVideoFile != null) {
      await _handleSavePrimary();
    } else {
      setState(() => _isExporting = true);
      try {
        await VerseCardExporter.shareCard(
          context: context,
          boundaryKey: _cardKey,
          verse: _currentVerse,
        );
      } finally {
        if (mounted) setState(() => _isExporting = false);
      }
    }
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
                onPickAyah: _openAyahPicker,
              ),
              // Luxury Mode Switcher: [ 🖼️ تَصْمِيمُ صُورَة (4K) ] | [ 🎬 صَانِعُ فِيدْيُو رِيلْز ]
              _VerseCardStudioModeSwitcher(
                isVideoMode: isVideoMode,
                onModeChanged: _handleModeChanged,
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
                          aspectRatio: isVideoMode ? (9 / 16) : 0.94,
                          child: VerseCardDisplay(
                            cardKey: _cardKey,
                            overlayKey: _overlayKey,
                            verse: _currentVerse,
                            presetAsset: _customImageFile == null &&
                                    _customVideoFile == null
                                ? _selectedPresetAsset
                                : null,
                            customImageFile: _customImageFile,
                            videoController: _videoController,
                            reciterName: _selectedReciter.nameArabic,
                            isPlayingRecitation: _isPlaying,
                            isOverlayOnly: _isExporting,
                            onBadgeTap: _openAyahPicker,
                            currentAyahDisplayIndex: _currentAyahDisplayIndex,
                          ),
                        ),
                      ),

                      // If in Video Mode: Show hero picker if no video, or controls if video selected
                      if (isVideoMode) ...[
                        if (_customVideoFile == null) ...[
                          _VideoUploadHeroCard(onPickVideo: _pickCustomVideo),
                        ] else ...[
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colors.accentGold,
                                side: BorderSide(
                                  color: colors.accentGold.withValues(alpha: 0.5),
                                  width: 0.8.r,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                              ),
                              onPressed: _pickCustomVideo,
                              icon: Icon(Iconsax.video_vertical,
                                  size: 16.r, color: colors.accentGold),
                              label: Text(
                                'تَغْيِيرُ مَقْطَعِ الفِيدْيُو مِنَ الِاسْتُودْيُو',
                                style: GoogleFonts.cairo(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.accentGold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (_videoDurationSeconds > 0) ...[
                          SizedBox(height: 8.h),
                          VerseCardDurationMatcherChip(
                            videoDurationSeconds: _videoDurationSeconds,
                            currentVerse: _currentVerse,
                            onAutoMatchVerse: _autoMatchVerseToVideo,
                            onPickAyahRange: _openAyahPicker,
                          ),
                        ],
                        SizedBox(height: 14.h),
                        // Playback bar strictly active for Video Mode
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
                      ] else ...[
                        // In Image Mode: Clean background selector with zero audio playback bar
                        SizedBox(height: 16.h),
                        VerseCardBackgroundSelector(
                          selectedPresetAsset: _selectedPresetAsset,
                          hasCustomImage: _customImageFile != null,
                          hasCustomVideo: false,
                          onSelectPreset: _selectPresetAsset,
                          onPickCustomImage: _pickCustomImage,
                          onPickCustomVideo: _pickCustomVideo,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.h,
                  bottom: bottomPadding > 0 ? bottomPadding + 8.h : 18.h,
                ),
                child: VerseCardActionsRow(
                  isExporting: _isExporting,
                  isVideoMode: isVideoMode,
                  onSavePrimary: _handleSavePrimary,
                  onSaveImageSecondary:
                      isVideoMode ? _handleSaveImageSecondary : null,
                  onShareCard: _handleShareCard,
                  onCopyText: _handleCopyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Segmented mode switcher at the top of the studio canvas.
class _VerseCardStudioModeSwitcher extends StatelessWidget {
  final bool isVideoMode;
  final ValueChanged<bool> onModeChanged;

  const _VerseCardStudioModeSwitcher({
    required this.isVideoMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 0.8.r,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTabItem(
              title: 'تَصْمِيمُ صُورَة',
              icon: Iconsax.image,
              isSelected: !isVideoMode,
              onTap: () => onModeChanged(false),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: _ModeTabItem(
              title: 'فِيدْيُو رِيلْز',
              icon: Iconsax.video_play,
              isSelected: isVideoMode,
              onTap: () => onModeChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTabItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentGold : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15.r,
              color: isSelected ? colors.background : colors.textSecondary,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? colors.background : colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Large prominent hero card displayed in Video Mode when no video has been chosen yet.
class _VideoUploadHeroCard extends StatelessWidget {
  final VoidCallback onPickVideo;

  const _VideoUploadHeroCard({required this.onPickVideo});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colors.accentGold.withValues(alpha: 0.45),
          width: 1.r,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accentGold.withValues(alpha: 0.15),
            ),
            child: Icon(
              Iconsax.video_add,
              size: 28.r,
              color: colors.accentGold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'صَانِعُ فِيدْيُوهَاتِ الرِّيلْز القُرْآنِيَّة',
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'اخْتَرْ مَقْطَعًا مِنَ اسْتُودْيُو هَاتِفِكَ (حَتَّى 30 ثَانِيَة) لِدَمْجِهِ مَعَ تِلَاوَةِ القَارِئِ وَخُطُوطِ الآيَاتِ',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accentGold,
              foregroundColor: colors.background,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              HapticService.selectionClick();
              onPickVideo();
            },
            icon: Icon(Iconsax.gallery_add, size: 16.r, color: colors.background),
            label: Text(
              'اخْتِيَارُ مَقْطَعِ فِيدْيُو مِنَ الِاسْتُودْيُو',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

