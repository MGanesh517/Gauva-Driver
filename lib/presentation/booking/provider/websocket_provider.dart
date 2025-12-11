import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/websocket_notifier.dart';

final webSocketNotifierProvider = StateNotifierProvider<WebSocketNotifier, void>((ref) => WebSocketNotifier(ref));
