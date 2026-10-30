import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_greeting_hero.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_top_bar.dart';

/// Master sanctuary header composing the sacred brand identity,
/// time-aware spiritual greeting, Hijri status, and live prayer countdown.
class MaladhHeader extends StatelessWidget {
  final MaladhHeaderData data;
  final VoidCallback? onNotificationTap;

  const MaladhHeader({
    super.key,
    required this.data,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Brand Crest & Action Top Bar
        MaladhTopBar(
          onNotificationTap: onNotificationTap,
        ),

        SizedBox(height: 10.h),

        // 2. Greeting Hero (Time greeting, Dhikr subtitle, Hijri date, Next prayer ticker)
        MaladhGreetingHero(data: data),

        AppSpacing.verticalSm,
      ],
    );
  }
}
