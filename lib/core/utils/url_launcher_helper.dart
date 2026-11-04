import 'package:flutter/material.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper utility for safely opening external links and web destinations.
abstract final class UrlLauncherHelper {
  /// Official Sakina Privacy Policy & Data Protection URL
  static const String privacyPolicyUrl =
      'https://m-fawzy2004.github.io/sakina_privacy_policy/';

  /// Opens [urlString] safely in external browser with haptics and user feedback.
  static Future<void> openUrl(BuildContext context, String urlString) async {
    HapticService.selectionClick();
    try {
      final uri = Uri.parse(urlString);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await launchUrl(uri);
      }
    } catch (e, st) {
      AppLogger.error('Failed to launch URL: $urlString', e, st, 'URL_LAUNCHER');
      if (context.mounted) {
        AppTopSnackBar.show(
          context: context,
          message: 'تعذر فتح الرابط، يرجى التحقق من المتصفح والاتصال بالإنترنت',
        );
      }
    }
  }

  /// Opens the official Sakina Privacy Policy document.
  static Future<void> openPrivacyPolicy(BuildContext context) async {
    await openUrl(context, privacyPolicyUrl);
  }
}

