import 'package:flutter/material.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

bool isDarkMode() => Theme.of(NavigationService.navigatorKey.currentContext!).brightness == Brightness.dark;
