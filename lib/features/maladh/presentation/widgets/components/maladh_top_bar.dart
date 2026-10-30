import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_brand_badge.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/maladh_glass_icon_button.dart';

/// Top bar component presenting the sacred brand crest and notification action.
class MaladhTopBar extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const MaladhTopBar({
    super.key,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Right Side (RTL Start): Sacred Brand Logo & Title
          const MaladhBrandBadge(),

          // 2. Left Side (RTL End): Notification Action
          MaladhGlassIconButton(
            icon: HugeIcons.strokeRoundedNotification03,
            showBadge: true,
            onTap: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
