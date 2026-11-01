import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/audio_reciters/domain/entities/recitation_track_entity.dart';

/// Representation of a verified Live Holy Sanctuary Broadcast stream.
class LiveSanctuaryChannel {
  final int id;
  final String name;
  final String sanctuary;
  final String subtitle;
  final String iconEmoji;
  final String streamUrl;

  const LiveSanctuaryChannel({
    required this.id,
    required this.name,
    required this.sanctuary,
    required this.subtitle,
    required this.iconEmoji,
    required this.streamUrl,
  });

  /// Converts the live channel into a RecitationTrackEntity for seamless player integration.
  RecitationTrackEntity toTrack() {
    return RecitationTrackEntity(
      id: 990000 + id,
      reciterId: 999,
      reciterName: sanctuary,
      surahId: 0,
      surahNameArabic: name,
      styleDescription: subtitle,
      audioUrl: streamUrl,
      duration: Duration.zero,
      riwayah: 'بث مباشر 24/7',
    );
  }
}

/// Official verified MP3Quran Live TV broadcast streams (Makkah & Madinah).
const List<LiveSanctuaryChannel> kSanctuaryLiveChannels = [
  LiveSanctuaryChannel(
    id: 3,
    name: 'قناة القرآن الكريم',
    sanctuary: 'المسجد الحرام • مكة المكرمة',
    subtitle: 'بث حي متواصل من الكعبة المشرفة',
    iconEmoji: '🕋',
    streamUrl: 'https://win.holol.com/live/quran/playlist.m3u8',
  ),
  LiveSanctuaryChannel(
    id: 4,
    name: 'قناة السنة النبوية',
    sanctuary: 'المسجد النبوي • المدينة المنورة',
    subtitle: 'بث حي متواصل من الروضة الشريفة',
    iconEmoji: '🕌',
    streamUrl: 'https://win.holol.com/live/sunnah/playlist.m3u8',
  ),
];

/// Luxury Live TV Section displaying Makkah & Madinah live broadcasts.
/// Built with zero drop-shadows and rich spiritual styling.
class LiveStreamChannelsSection extends StatelessWidget {
  final RecitationTrackEntity? currentTrack;
  final bool isPlaying;
  final ValueChanged<RecitationTrackEntity> onChannelTap;

  const LiveStreamChannelsSection({
    super.key,
    required this.currentTrack,
    required this.isPlaying,
    required this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "البث المباشر" + Pulsing Live Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'البث المباشر',
                        style: GoogleFonts.cairo(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const _PulsingLiveChip(),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'الحرمين الشريفين',
                style: GoogleFonts.cairo(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.accentGold,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // 2 Luxury Live Cards (Side-by-Side)
          Row(
            children: [
              Expanded(
                child: _LiveChannelCard(
                  channel: kSanctuaryLiveChannels[0],
                  isCurrentPlaying: isPlaying &&
                      currentTrack?.audioUrl == kSanctuaryLiveChannels[0].streamUrl,
                  onTap: () => onChannelTap(kSanctuaryLiveChannels[0].toTrack()),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _LiveChannelCard(
                  channel: kSanctuaryLiveChannels[1],
                  isCurrentPlaying: isPlaying &&
                      currentTrack?.audioUrl == kSanctuaryLiveChannels[1].streamUrl,
                  onTap: () => onChannelTap(kSanctuaryLiveChannels[1].toTrack()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveChannelCard extends StatelessWidget {
  final LiveSanctuaryChannel channel;
  final bool isCurrentPlaying;
  final VoidCallback onTap;

  const _LiveChannelCard({
    required this.channel,
    required this.isCurrentPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isCurrentPlaying ? colors.surfaceElevated : colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isCurrentPlaying
                  ? colors.accentGold
                  : colors.borderHairline.withValues(alpha: 0.65),
              width: isCurrentPlaying ? 1.5.r : 1.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Emoji Icon + Live Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surfaceElevated,
                      border: Border.all(
                        color: colors.borderHairline.withValues(alpha: 0.6),
                        width: 0.8.r,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      channel.iconEmoji,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                    decoration: BoxDecoration(
                      color: isCurrentPlaying
                          ? colors.accentGold.withValues(alpha: 0.18)
                          : const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isCurrentPlaying
                            ? colors.accentGold
                            : const Color(0xFFEF4444).withValues(alpha: 0.5),
                        width: 0.8.r,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.r,
                          height: 5.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrentPlaying
                                ? colors.accentGold
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isCurrentPlaying ? 'مُشغل' : 'LIVE',
                          style: GoogleFonts.cairo(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: isCurrentPlaying
                                ? colors.accentGold
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Channel Name
              Text(
                channel.name,
                style: GoogleFonts.cairo(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                  color: isCurrentPlaying ? colors.accentGold : colors.textPrimary,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),

              // City / Sanctuary Name
              Text(
                channel.sanctuary,
                style: GoogleFonts.cairo(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.accentGold.withValues(alpha: 0.9),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),

              // Action Bar
              Row(
                children: [
                  Icon(
                    isCurrentPlaying ? Iconsax.pause : Iconsax.play,
                    size: 13.r,
                    color: isCurrentPlaying ? colors.accentGold : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      isCurrentPlaying ? 'إيقاف البث' : 'تشغيل البث المباشر',
                      style: GoogleFonts.cairo(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isCurrentPlaying
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingLiveChip extends StatefulWidget {
  const _PulsingLiveChip();

  @override
  State<_PulsingLiveChip> createState() => _PulsingLiveChipState();
}

class _PulsingLiveChipState extends State<_PulsingLiveChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.4 + (_controller.value * 0.6)),
              width: 0.8.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    const Color(0xFFDC2626),
                    const Color(0xFFF87171),
                    _controller.value,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'مباشر',
                style: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
