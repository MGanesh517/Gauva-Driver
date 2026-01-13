import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/app.dart';
import 'package:gauva_driver/core/widgets/connectivity_wrapper.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/notification_service.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final FirebaseAnalytics _ = FirebaseAnalytics.instance;
  await NotificationService().handleBackgroundNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await initializeFirebase();
  await dotenv.load();
  await LocalStorageService().init();
  await NotificationService().init();

  // ✅ Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Handle tap when app is terminated
  final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    await handleNotificationTap(initialMessage);
  }

  // Prevent tree-shaking of overlay entry point
  try {
    // ignore: unnecessary_statements
    overlayMain;
  } catch (e) {
    // ignore
  }

  runApp(const ProviderScope(child: GlobalConnectivityWrapper(child: MyApp())));
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

// Overlay entry point
@pragma('vm:entry-point')
void overlayMain() {
  debugPrint('🟢 OV: Starting Overlay Entry Point...');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayWidget()));
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint('🟢 OV: OverlayWidget Initialized');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🟢 OV: OverlayWidget Building...');
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            // Use AndroidIntent to launch with FLAG_ACTIVITY_NEW_TASK
            const intent = AndroidIntent(
              action: 'android.intent.action.VIEW',
              data: 'gauvadriver://open',
              flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            );
            await intent.launch();
            debugPrint("� AndroidIntent launch called");
          },
          child: Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.25),
              //     blurRadius: 10,
              //     spreadRadius: 2,
              //     offset: const Offset(0, 0),
              //   ),
              // ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  'assets/images/app-logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_taxi, color: Colors.black, size: 40),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
