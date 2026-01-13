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
    print("📱 Lifecycle State Changed: $state");
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App went to background or became inactive
      print("📱 App paused/inactive, checking overlay...");
      // Small delay to ensure app is fully in background
      await Future.delayed(const Duration(milliseconds: 300));
      _checkAndShowOverlay();
    } else if (state == AppLifecycleState.resumed) {
      // App came to foreground
      print("📱 App resumed, closing overlay...");
      await FlutterOverlayWindow.closeOverlay();
    }
  }

  Future<void> _checkAndShowOverlay() async {
    try {
      final orderId = await LocalStorageService().getOrderId();
      final isOnline = await LocalStorageService().getOnlineOffline();

      print("🔍 Overlay Check -> OrderID: $orderId, isOnline: $isOnline");

      // Show overlay if there is an active order OR if the driver is online
      // This matches Rapido Captain behavior - always visible when online
      if ((orderId != null && orderId > 0) || isOnline) {
        // Check permission first
        final bool status = await FlutterOverlayWindow.isPermissionGranted();
        print("🔍 Overlay Permission Granted: $status");

        if (!status) {
          print("❌ Overlay permission NOT granted.");
          return;
        }

        // Check if overlay is already showing
        final bool isActive = await FlutterOverlayWindow.isActive();
        if (isActive) {
          print("ℹ️ Overlay already active, skipping show.");
          return;
        }

        // Double-check app is still in background
        final currentState = WidgetsBinding.instance.lifecycleState;
        if (currentState != AppLifecycleState.paused && 
            currentState != AppLifecycleState.inactive) {
          print("⚠️ App returned to foreground, aborting overlay show.");
          return;
        }

        print("🚀 Attempting to show overlay...");
        await FlutterOverlayWindow.showOverlay(
          enableDrag: true,
          overlayTitle: "Gauva Partner",
          overlayContent: orderId != null && orderId > 0 ? 'Active Ride' : 'Online',
          flag: OverlayFlag.focusPointer, // Ensures visibility
          alignment: OverlayAlignment.centerLeft, // Left side like Rapido
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.left, // Dock to left side
          height: 110, // Match overlay_widget.dart size (increased from 80)
          width: 110,
        );
        print("✅ FlutterOverlayWindow.showOverlay called successfully.");
      } else {
        print("⚠️ Overlay not shown: Driver is Offline and No Active Order.");
        // Close overlay if driver goes offline
        final bool isActive = await FlutterOverlayWindow.isActive();
        if (isActive) {
          await FlutterOverlayWindow.closeOverlay();
        }
      }
    } catch (e) {
      print("❌ Error showing overlay: $e");
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
