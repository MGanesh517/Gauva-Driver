import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> deviceTokenFirebase() async {
  print('🔥 deviceTokenFirebase() called');
  try {
    final token = Platform.isIOS ? await iosDeviceToken() : await FirebaseMessaging.instance.getToken();
    print('🔥 FCM Token: $token');
    return token;
  } catch (e) {
    print('❌ Error getting FCM token: $e');
    return null;
  }
}

Future<String?> iosDeviceToken() async {
  await FirebaseMessaging.instance.requestPermission(
    // alert: true,
    // badge: true,
    // sound: true,
  );
  final token = await FirebaseMessaging.instance.getAPNSToken();
  print('🔥 APNS Token: $token');
  return token;
}
