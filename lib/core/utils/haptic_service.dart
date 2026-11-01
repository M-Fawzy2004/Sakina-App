import 'package:flutter/services.dart';

abstract final class HapticService {
  /// Tab selection, bottom nav switch, or discrete segment selection.
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Toggle switches, play/pause toggles, or secondary action buttons.
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Setting a bookmark, marking an ayah as read, or resetting progress.
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Primary sacred actions, bookmark locking, or inaba refuge activation.
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Completing a thikr repetition target or completing a sacred task.
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  /// Rhythmic sensory feedback sequence for the Inaba Recovery emergency pulse.
  static Future<void> emergencyPulsation() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
  }
}

