import 'package:final_thesis_app/app/services/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {

  late final Chat currentChat;
  late final Stream<List<Message>> messagesStream;

  @override
  FutureOr<List<Message>?> build (Chat chat) async {
    currentChat = chat;
    final messageService = ref.watch(messageServiceProvider);
    
    messagesStream = messageService.listenToChatMessages(chat.id).map((messages) {
      final sorted = messages?.toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return sorted ?? [];
    });
  }
}