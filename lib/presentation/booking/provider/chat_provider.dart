import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/chat_message_response/chat_message.dart';
import '../../../data/repositories/chat_repo_impl.dart';
import '../../../data/repositories/interfaces/chat_repo_interface.dart';
import '../../../data/services/chat_service.dart';
import '../../../domain/interfaces/chat_service.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/chat_notifier.dart';

// Service Provider
final chatServiceProvider = Provider<IChatService>((ref) => ChatService(dioClient: ref.read(dioClientChattingProvider)));

// Repo Provider
final chatRepoProvider = Provider<IChatRepo>((ref) => ChatRepoImpl(chatService: ref.read(chatServiceProvider)));

// ViewModel Provider
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, AppState<List<Message>>>(
      (ref) {
    final repo = ref.read(chatRepoProvider);
    return ChatNotifier(chatRepo: repo, ref: ref);
  },
);


