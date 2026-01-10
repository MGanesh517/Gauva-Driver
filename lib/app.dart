import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:gauva_driver/core/routes/app_router.dart';
import 'package:gauva_driver/presentation/account_page/provider/theme_provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/fonts.dart';
import 'core/theme/theme.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/navigation_service.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check if we opened from overlay
    _checkOverlayShareData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App went to background
      _checkAndShowOverlay();
    } else if (state == AppLifecycleState.resumed) {
      // App came to foreground
      await FlutterOverlayWindow.closeOverlay();
    }
  }

  Future<void> _checkAndShowOverlay() async {
    try {
      final orderId = await LocalStorageService().getOrderId();
      final isOnline = await LocalStorageService().getOnlineOffline();

      // Show overlay if there is an active order OR if the driver is online
      if ((orderId != null && orderId > 0) || isOnline) {
        // Check permission first
        final bool status = await FlutterOverlayWindow.isPermissionGranted();
        if (!status) {
          return;
        }

        String overlayMessage = 'Online';
        if (orderId != null && orderId > 0) {
          overlayMessage = 'Active Ride';
        }

        await FlutterOverlayWindow.showOverlay(
          enableDrag: true,
          overlayTitle: "Gauva Driver",
          overlayContent: overlayMessage,
          flag: OverlayFlag.defaultFlag,
          alignment: OverlayAlignment.center,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.none,
          height: 250,
          width: 250,
        );
      }
    } catch (e) {
      print("Error showing overlay: $e");
    }
  }

  Future<void> _checkOverlayShareData() async {
    // If opened from overlay, close it specifically (double check)
    if (await FlutterOverlayWindow.isActive()) {
      await FlutterOverlayWindow.closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) => ValueListenableBuilder<String>(
        valueListenable: LocalStorageService().languageNotifier,
        builder: (context, localeCode, _) => SafeArea(
          bottom: true,
          top: false,
          right: false,
          left: false,
          child: MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: dotenv.env['APP_NAME'] ?? '',
            themeMode: themeMode,
            theme: AppTheme.light(Fonts.primary, Fonts.secondary),
            darkTheme: AppTheme.dark(Fonts.primary, Fonts.secondary),
            locale: Locale(localeCode),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
          ),
        ),
      ),
    );
  }
}
