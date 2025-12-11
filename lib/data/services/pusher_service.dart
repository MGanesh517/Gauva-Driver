import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _isInitialized = false;
  final Set<String> _subscribedChannels = {};
  static final String _apiKey = dotenv.env['PUSHER_API_KEY']!;
  static final String _cluster = dotenv.env['PUSHER_CLUSTER']!;

  Future<int?> getDriverId() async {
    final user = await LocalStorageService().getUserId();
    return user;
  }

  Future<void> init({
    dynamic Function(String, String)? onConnectionStateChange,
    dynamic Function(String, int?, dynamic)? onError,
    dynamic Function(PusherEvent)? onEvent,
    dynamic Function(String, dynamic)? onSubscriptionSucceeded,
    dynamic Function(String, String, dynamic)? onAuthorizer,
    Map<String, Map<String, String>>? authParams,
    bool? logToConsole,
    dynamic Function(String, dynamic)? onSubscriptionError,
    dynamic Function(String, String)? onDecryptionFailure,
    dynamic Function(String, PusherMember)? onMemberAdded,
    dynamic Function(String, PusherMember)? onMemberRemoved,
    dynamic Function(String, int)? onSubscriptionCount,
  }) async {
    if (_isInitialized) {
      return;
    }

    await _pusher
        .init(
          apiKey: _apiKey,
          cluster: _cluster,
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onEvent: onEvent,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          authParams: authParams,
          logToConsole: logToConsole,
          onSubscriptionError: onSubscriptionError,
          onDecryptionFailure: onDecryptionFailure,
          onMemberAdded: onMemberAdded,
          onMemberRemoved: onMemberRemoved,
          onSubscriptionCount: onSubscriptionCount,
        )
        .then((_) {});

    _isInitialized = true;
    await connect();
  }

  Future<void> connect() async {
    if (_isInitialized) {
      await _pusher.connect();
    }
  }

  Future<void> disconnect() async {
    if (_isInitialized) {
      await _pusher.disconnect();
      _isInitialized = false;
      _subscribedChannels.clear();
    }
  }

  Future<void> subscribeChannel(String channelName) async {
    if (!_isInitialized) {
      return;
    }

    try {
      // Forcefully unsubscribe before subscribing
      await _pusher.unsubscribe(channelName: channelName);
      _subscribedChannels.remove(channelName);
    } catch (e) {
      // Ignore if not previously subscribed
    }

    try {
      await _pusher.subscribe(channelName: channelName);
      _subscribedChannels.add(channelName);
    } catch (e) {
      if (true) {}
    }
  }

  Future<void> unsubscribeChannel(String channelName) async {
    if (_subscribedChannels.contains(channelName)) {
      try {
        await _pusher.unsubscribe(channelName: channelName);
        _subscribedChannels.remove(channelName);
      } catch (e) {
        if (true) {}
      }
    }
  }

  Future<void> safeResubscribe(String channelName) async {
    await unsubscribeChannel(channelName);
    await subscribeChannel(channelName);
  }

  Future<void> unsubscribeAllChannels() async {
    for (final channel in _subscribedChannels.toList()) {
      await unsubscribeChannel(channel);
    }
    _subscribedChannels.clear();
  }

  Future<void> disconnectAndUnsubscribeAll() async {
    await unsubscribeAllChannels();
    await disconnect();
  }

  Future<void> reset() async {
    await disconnectAndUnsubscribeAll();
  }

  bool isSubscribed(String channelName) => _subscribedChannels.contains(channelName);

  Set<String> getSubscribedChannels() => _subscribedChannels;
}
