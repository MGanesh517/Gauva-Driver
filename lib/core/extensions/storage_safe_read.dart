import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

extension SafeRead on FlutterSecureStorage {
  Future<String?> safeRead({required String key}) async {
    try {
      return await read(key: key);
    } catch (e) {
      // BAD_DECRYPT or decryption error will corrupted value deleted
      debugPrint('-----------❌ Error reading secure key "$key": $e');
      await delete(key: key);
      return null;
    }
  }
}
