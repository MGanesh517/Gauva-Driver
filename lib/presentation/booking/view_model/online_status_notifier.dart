import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnlineStatusNotifier extends ValueNotifier<bool> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _key = 'activity';

  OnlineStatusNotifier() : super(false) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final val = await _storage.read(key: _key);
    value = val == 'true';
  }

  Future<void> setOnline(bool isOnline) async {
    value = isOnline;
    await _storage.write(key: _key, value: isOnline.toString());
  }
}
