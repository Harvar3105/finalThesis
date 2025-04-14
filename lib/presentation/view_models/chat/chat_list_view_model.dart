

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../data/domain/chat.dart';
import '../../../data/domain/user.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  Future<List<(Chat, String?, User?)>?> build() async {
    final chatService = ref.watch(chatServiceProvider);
    final userService = ref.watch(userServiceProvider);
    final messageService = ref.watch(messageServiceProvider);

    final user = await userService.getCurrentUser();
    if (user == null) {
      throw Exception("Failed to get current user");
    }

    final chats = await chatService.getChatsByUserId(user.id!);
    if (chats == null || chats.isEmpty) return null;

    final result = await Future.wait(
      chats.map((chat) async {
        final message = await messageService.getLastChatMessage(chat.id!);

        if (message == null) {
          return (chat, null, null);
        }

        final user = await userService.getUserById(message.senderId);
        return (chat, message.text, user);
      }),
    );

    return result;
  }
}