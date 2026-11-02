import 'dart:async';
import 'package:flutter/material.dart';

/// Manages smooth background timer execution for hands-free Quran auto-scrolling.
class ReaderAutoScrollTimer {
  Timer? _timer;
  bool isPaused = false;

  void start({
    required double speed,
    required ScrollController Function() getController,
    required bool Function() canAdvancePage,
    required VoidCallback onAdvancePage,
  }) {
    stop();
    isPaused = false;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (isPaused) return;
      final controller = getController();
      if (!controller.hasClients) return;

      final maxScroll = controller.position.maxScrollExtent;
      final currentScroll = controller.position.pixels;
      if (currentScroll >= maxScroll) {
        if (canAdvancePage()) {
          onAdvancePage();
        } else {
          stop();
        }
        return;
      }
      final step = 0.8 * speed;
      controller.jumpTo(currentScroll + step);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void togglePause() {
    isPaused = !isPaused;
  }

  void dispose() {
    stop();
  }
}

