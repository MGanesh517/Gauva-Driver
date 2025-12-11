import 'package:flutter/cupertino.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

bool isArabic() => Localizations.localeOf(NavigationService.navigatorKey.currentContext!).languageCode == 'ar';
