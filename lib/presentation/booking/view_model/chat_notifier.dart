import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/app_state.dart';
import '../../../data/models/chat_message_response/chat_message.dart';
import '../../../data/repositories/interfaces/chat_repo_interface.dart';
import '../../../data/services/local_storage_service.dart';
import '../provider/ride_providers.dart';
import '../views/sheets/chat_sheet.dart';

class ChatNotifier extends StateNotifier<AppState<List<Message>>> {
  final IChatRepo chatRepo;
  final Ref ref;
  ChatNotifier( {required this.chatRepo, required this.ref
  }) : super(const AppState.initial()) {getMessage();}


  Future<void> getMessage() async {
    state = const AppState.loading();
    final raiderId = ref.watch(rideOrderNotifierProvider).maybeWhen(orElse: ()=> null, success: (data)=> data?.rider?.id);

    final result = await chatRepo.getMessage(userId: (raiderId ?? 0).toInt());
    result.fold(
          (failure) => state = AppState.error(failure),
          (data) {
            state = AppState.success(data.data);
            _scrollToBottom(milliseconds: 5);
          },
    );
  }

  Future<void> sendMessage({required TextEditingController message}) async {

    final String text = message.text.trim();
    await updateMsgList(text);
    message.clear();

    final raiderId = ref.read(rideOrderNotifierProvider).maybeWhen(orElse: ()=> null, success: (data)=> data?.rider?.id);

    final result = await chatRepo.sendMessage(
      receiverId: (raiderId ?? 0).toInt(),
      message: text,
    );

    result.fold(
          (failure) {
        state = AppState.error(failure);
      },
          (data) async {},
    );
  }

  Future<void> addMessage(Message message) async {
    state.maybeWhen(
      success: (messages) {
        final updatedList = [...messages, message];
        state = AppState.success(updatedList);
        _scrollToBottom();
      },
      orElse: () {
        state = AppState.success([message]);
      },
    );
  }

  void _scrollToBottom({int milliseconds = 300}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // void jumpTo(){
  //   Future.delayed(const Duration(milliseconds: 200)).then((_){
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (scrollController.hasClients) {
  //         scrollController.jumpTo(
  //           scrollController.position.maxScrollExtent,
  //           // duration: const Duration(milliseconds: 300),
  //           // curve: Curves.easeOut,
  //         );
  //       }});
  //   });
  //
  //   }


  Future<void> updateMsgList(String message)async{
    final prevMsg = state.whenOrNull(success: (data)=> data) ?? [];
    final user = await LocalStorageService().getSavedUser();
    final riderId = ref.read(rideOrderNotifierProvider).maybeWhen(orElse: ()=> 0, success: (data)=> (data?.rider?.id ?? 0).toInt());
    state = AppState.success([...prevMsg, Message(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: user?.id ?? 0,
      receiverId: riderId,
      message: message,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )]);
    _scrollToBottom();
  }
}
