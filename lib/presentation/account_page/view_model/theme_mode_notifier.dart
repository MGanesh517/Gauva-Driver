import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/set_status_bar_color.dart';

import '../../../data/services/local_storage_service.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  final _local = LocalStorageService();

  Future<void> _loadTheme() async {
    final savedTheme = await _local.getThemeMode();
    state = _themeModeFromString(savedTheme);
    setStatusBarColor(change: true);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _local.setTheme(_themeModeToString(mode));
    setStatusBarColor();
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  bool isDarkMode() => state == ThemeMode.dark;
}
