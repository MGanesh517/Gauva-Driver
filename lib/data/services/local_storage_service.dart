import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gauva_driver/core/extensions/storage_safe_read.dart';
import 'package:gauva_driver/data/models/remote_message_model/remote_message_model.dart';
import '../models/hive_models/user_hive_model.dart';
import 'api/dio_interceptors.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _languageKey = 'language';
  static const String _remoteMessageKey = 'remote_message';

  final ValueNotifier<String> languageNotifier = ValueNotifier('en');

  Future<void> init() async {
    final lang = await _storage.safeRead(key: _languageKey);
    languageNotifier.value = lang ?? 'en';
  }

  Future<void> saveRemoteMessage({required Map<String, dynamic> msg}) async =>
      await _storage.write(key: _remoteMessageKey, value: jsonEncode(msg));

  Future<RemoteMessageModel?> getRemoteMessage() async {
    try {
      final json = await _storage.safeRead(key: _remoteMessageKey);
      if (json == null) return null;
      return RemoteMessageModel.fromJson(jsonDecode(json));
    } catch (e) {
      // delayShowMessage(show: (){showNotification(message: 'from local storage $e');},);
      return null;
    }
  }

  Future<void> clearRemoteMessage() async => await _storage.delete(key: _remoteMessageKey);

  Future<void> selectLanguage(String language) async {
    await _storage.write(key: _languageKey, value: language);
    languageNotifier.value = language;
  }

  Future<String> getSelectedLanguage() async => await _storage.safeRead(key: _languageKey) ?? 'en';

  Future<void> savePhoneCode(String countryCode) async {
    await _storage.write(key: 'country-code', value: countryCode);
  }

  Future<String> getCountryCode() async {
    final value = await _storage.safeRead(key: 'country-code');
    return value ?? '+880';
  }

  void setTheme(String mode) {
    _storage.write(key: 'themeMode', value: mode);
  }

  Future<String> getThemeMode() async => await _storage.safeRead(key: 'themeMode') ?? 'light';

  Future<void> saveUser({required Map<String, dynamic>? data}) async {
    if (data != null) {
      try {
        print('💾 LocalStorage: Saving user data...');
        final model = UserHiveModel.fromMap(data);
        print('💾 LocalStorage: User ID from model: ${model.id}');
        final encoded = jsonEncode(model.toMap());
        await _storage.write(key: 'user', value: encoded);
        print('✅ LocalStorage: User data saved successfully');

        // Verify it was saved
        final savedUser = await getSavedUser();
        if (savedUser != null) {
          print('✅ LocalStorage: User data verified - ID: ${savedUser.id}');
        } else {
          print('❌ LocalStorage: User data was not saved properly!');
        }

        setOnlineOffline(model.driverStatus?.toLowerCase() == 'online');
      } catch (e) {
        print('❌ LocalStorage: Error saving user data: $e');
        rethrow;
      }
    } else {
      print('⚠️ LocalStorage: Attempted to save null user data');
    }
  }

  void setRegistrationProgress(String pageName) {
    _storage.write(key: 'registration', value: pageName);
  }

  Future<String?> getRegistrationProgress() => _storage.safeRead(key: 'registration');

  Future<void> setOnlineOffline([bool isOnline = false]) async {
    await _storage.write(key: 'activity', value: isOnline.toString());
  }

  Future<bool> getOnlineOffline() async {
    final value = await _storage.safeRead(key: 'activity');
    return value == 'true';
  }

  Future<UserHiveModel?> getSavedUser() async {
    final json = await _storage.safeRead(key: 'user');
    if (json != null) {
      final map = jsonDecode(json);
      return UserHiveModel.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<int?> getUserId() async {
    try {
      final user = await getSavedUser();
      if (user == null) {
        print('⚠️ LocalStorage: getUserId() - No user data object found in storage');
        return null;
      }
      if (user.id == null) {
        print(
          '⚠️ LocalStorage: getUserId() - User data exists but ID field is null. User data: ${jsonEncode(user.toMap())}',
        );
        return null;
      }
      print('✅ LocalStorage: getUserId() - Found driver ID: ${user.id}');
      return user.id;
    } catch (e) {
      print('❌ LocalStorage: Error getting user ID: $e');
      return null;
    }
  }

  Future<void> saveToken(String? token) async {
    if (token == null || token.isEmpty) {
      print('⚠️ LocalStorage: Attempted to save null or empty token');
      return;
    }
    try {
      await _storage.write(key: 'token', value: token);
      print('✅ LocalStorage: Token saved successfully (length: ${token.length})');
      
      // Clear token cache so next request will use new token
      DioInterceptors.clearTokenCache();
      
      // Verify it was saved
      final savedToken = await _storage.safeRead(key: 'token');
      if (savedToken == null || savedToken.isEmpty) {
        print('❌ LocalStorage: Token was not saved properly!');
      } else {
        print('✅ LocalStorage: Token verified after save');
      }
    } catch (e) {
      print('❌ LocalStorage: Error saving token: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.safeRead(key: 'token');
      if (token == null || token.isEmpty) {
        print('⚠️ LocalStorage: No token found in storage');
        return null;
      }
      print('✅ LocalStorage: Token retrieved successfully (length: ${token.length})');
      return token;
    } catch (e) {
      print('❌ LocalStorage: Error retrieving token: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
    // Clear token cache when token is cleared
    DioInterceptors.clearTokenCache();
  }

  Future<void> clearUser() async {
    await _storage.delete(key: 'user');
  }

  Future<void> completeOnboarding() async {
    await _storage.write(key: 'onboarding', value: 'true');
  }

  Future<bool> isCompletedOnboarding() async {
    final value = await _storage.safeRead(key: 'onboarding');
    return value == 'true';
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.safeRead(key: 'token');
      final isLoggedIn = token != null && token.isNotEmpty;
      print(
        '🔍 LocalStorage: isLoggedIn check - Token exists: ${token != null}, Token length: ${token?.length ?? 0}, Result: $isLoggedIn',
      );
      return isLoggedIn;
    } catch (e) {
      print('❌ LocalStorage: Error checking login status: $e');
      return false;
    }
  }

  Future<void> saveChatState({required bool isOpen}) async {
    await _storage.write(key: 'chat-state', value: isOpen.toString());
  }

  Future<bool> getChatState() async {
    final value = await _storage.safeRead(key: 'chat-state');
    return value == 'true';
  }

  Future<void> saveOrderId(int? id) async {
    await _storage.write(key: 'order_id', value: id?.toString());
  }

  Future<int?> getOrderId() async {
    final value = await _storage.safeRead(key: 'order_id');
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> clearOrderId() async {
    await _storage.delete(key: 'order_id');
  }

  /// ---------------- App settings ----------------

  static const String _promotionalKey = 'promotional_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _notificationsKey = 'notifications_enabled';

  Future<void> setPromotional(bool value) async {
    await _storage.write(key: _promotionalKey, value: value.toString());
  }

  Future<bool> getPromotional() async {
    final value = await _storage.safeRead(key: _promotionalKey);
    return value == null ? true : value == 'true';
  }

  Future<void> setVibration(bool value) async {
    await _storage.write(key: _vibrationKey, value: value.toString());
  }

  Future<bool> getVibration() async {
    final value = await _storage.safeRead(key: _vibrationKey);
    return value == null ? true : value == 'true';
  }

  Future<void> setNotificationPermission(bool granted) async {
    await _storage.write(key: _notificationsKey, value: granted.toString());
  }

  Future<bool> getNotificationPermission() async {
    final value = await _storage.safeRead(key: _notificationsKey);
    return value == 'true';
  }

  /// ---------------- Clear Storage ----------------

  Future<void> clearStorage() async {
    await clearToken();
    await clearUser();
  }

  Future<void> destroyAll() async {
    await clearToken();
    await clearUser();
    await clearOrderId();
  }
}
