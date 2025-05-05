import 'dart:async';
import 'dart:developer';

import 'package:final_thesis_app/app/services/providers.dart';
import 'package:final_thesis_app/app/typedefs/entity.dart';
import 'package:final_thesis_app/data/domain/chat.dart';
import 'package:final_thesis_app/data/domain/message.dart';
import 'package:final_thesis_app/data/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {

  late final Chat currentChat;
  late final Stream<List<Message>> messagesStream;
  late final User currentUser;

  @override
  Future<ChatViewModel> build (Chat chat) async {
    currentChat = chat;
    final userService = ref.watch(userServiceProvider);
    final messageService = ref.watch(messageServiceProvider);
    
    currentUser = (await userService.getCurrentUser())!;

    messagesStream = messageService.listenToChatMessages(chat.id!).map((messages) {
      final sorted = messages?.toList()
        ?..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return sorted ?? [];
    });
    return this;
  }

  Future<bool> sendMessage(String text, Id senderId) async {
    final messageService = ref.read(messageServiceProvider);
    final message = Message(
      text: text,
      senderId: senderId,
      chatId: currentChat.id!,
    );

    final success = await messageService.saveOrUpdateMessage(MessagePayload().messageToMessagePayload(message));
    if (!success) {
      log("Could not send message!");
      return false;
    }
    return true;
  }
}