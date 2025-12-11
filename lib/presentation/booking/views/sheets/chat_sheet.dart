import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/exit_app_dialogue.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/data/services/url_launch_services.dart';

import '../../../../common/loading_view.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/state/state_order.dart';
import '../../../../core/theme/color_palette.dart';
import '../../../../core/widgets/buttons/app_back_button.dart';
import '../../../../data/models/chat_message_response/chat_message.dart';
import '../../../../data/models/order_response/order_model/order/order.dart';
import '../../../../gen/assets.gen.dart';
import '../../provider/chat_provider.dart';
import '../../provider/ride_providers.dart';
import 'chat_item_me.dart';
import 'chat_item_other_person.dart';

final scrollController = ScrollController();

class ChatSheet extends ConsumerStatefulWidget {
  const ChatSheet({super.key});

  @override
  ConsumerState<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends ConsumerState<ChatSheet> {
  final textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _initializeUserAndChat();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    LocalStorageService().saveChatState(isOpen: false);
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeUserAndChat() async {
    LocalStorageService().saveChatState(isOpen: true);
    final chatNotifier = ref.read(chatNotifierProvider.notifier);

    userId = await LocalStorageService().getUserId() ?? 0;
    Future.microtask(() async {
      await chatNotifier.getMessage();
    });
  }

  void _sendMessage() async {
    if (textEditingController.text.trim().isEmpty) return;

    final chatNotifier = ref.read(chatNotifierProvider.notifier);

    await chatNotifier.sendMessage(message: textEditingController);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      if (!isKeyboardOpen) return;

      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final rideOrderState = ref.watch(rideOrderNotifierProvider);

    _scrollToBottom();

    return ExitAppWrapper(
      child: Scaffold(
        backgroundColor: context.surface,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: !Platform.isIOS,
          child: Column(
            children: [
              _buildHeader(context, rideOrderState),
              Expanded(child: _buildChatList(chatState, rideOrderState)),
              _buildInputBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(AppState<List<Message>> chatState, AppStateOrder<Order?> createOrderState) => chatState.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const LoadingView(),
    error: (_) => const SizedBox.shrink(),
    success: (messages) => ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(8.r),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLastItem = index == messages.length - 1;
        final isMe = message.receiverId.toString() != userId.toString();

        return isMe
            ? ChatItemMe(
                message: message.message,
                dateTime: message.createdAt,
                showTime: isLastItem,
                image: _imageBuilder(40.h, 40.w, createOrderState),
              )
            : ChatItemOtherPerson(
                message: message.message,
                dateTime: message.createdAt,
                showTime: isLastItem,
                image: _imageBuilder(40.h, 40.w, createOrderState, showRiderImage: false),
              );
      },
    ),
  );

  Widget _buildInputBar(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    color: isDarkMode() ? Colors.black : Colors.white,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              isDense: true,
              hintText: localize(context).type_a_message,
              hintStyle: context.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
              ),
              border: _border(),
              focusedBorder: _border(true),
              enabledBorder: _border(),
              suffix: InkWell(
                onTap: _sendMessage,
                child: Assets.images.sendRight.image(height: 20.5.h, width: 20.w, fit: BoxFit.fill),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  OutlineInputBorder _border([bool isFocused = false]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: BorderSide(color: isFocused ? ColorPalette.primary50 : const Color(0xFFD7DAE0)),
  );

  Widget _buildHeader(BuildContext context, AppStateOrder<Order?> createOrderState) {
    final height = 44.h;
    final width = 44.w;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      margin: EdgeInsets.zero,
      color: context.theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, _) => AppBackButton(
              onPressed: () {
                LocalStorageService().saveChatState(isOpen: false);
                NavigationService.pop();
              },
            ),
          ),
          const SizedBox(width: 16),
          _imageBuilder(height, width, createOrderState, showRiderImage: false),
          const SizedBox(width: 12),
          Expanded(child: _buildRiderDetails(createOrderState, context)),
          InkWell(
            onTap: () => _handleCall(createOrderState),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
                border: isDarkMode() ? Border.all(color: Colors.white) : null,
              ),
              padding: EdgeInsets.all(7.r),
              child: Assets.images.phoneFlip.image(height: 25.h, width: 25.w, fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBuilder(
    double height,
    double width,
    AppStateOrder<Order?> createOrderState, {
    bool showRiderImage = true,
  }) => createOrderState.maybeWhen(
    success: (data) => ClipOval(
      child: CachedNetworkImage(
        imageUrl: showRiderImage ? data?.driver?.profilePicture ?? '' : data?.rider?.profilePicture ?? '',
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (_, __) => _buildImagePlaceholder(height, width),
        errorWidget: (_, __, ___) => _buildImageError(height, width),
      ),
    ),
    orElse: () => const CircleAvatar(backgroundColor: ColorPalette.primary50),
  );
  Widget _buildImagePlaceholder(double height, double width) => Container(
    height: height,
    width: width,
    color: Colors.grey[300],
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );

  Widget _buildImageError(double height, double width) => Container(
    height: height,
    width: width,
    color: Colors.grey,
    child: const Icon(Icons.error, color: Colors.white),
  );

  Widget _buildRiderDetails(AppStateOrder<Order?> createOrderState, BuildContext context) => createOrderState.maybeWhen(
    success: (data) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data?.rider?.name ?? (data?.rider?.mobile ?? 'N/A'), style: context.titleMedium),
        Gap(4.h),
        Text(
          '6 min ago',
          style: context.bodyMedium?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF687387),
          ),
        ),
      ],
    ),
    orElse: () => const SizedBox.shrink(),
  );

  void _handleCall(AppStateOrder<Order?> createOrderState) {
    createOrderState.maybeWhen(
      success: (data) {
        if (data?.rider?.mobile != null) {
          UrlLaunchServices.launchDialer(data?.rider!.mobile);
        }
      },
      orElse: () => null,
    );
  }
}
