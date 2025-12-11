import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> deviceTokenFirebase() async =>
    Platform.isIOS ? await iosDeviceToken() : await FirebaseMessaging.instance.getToken();

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
