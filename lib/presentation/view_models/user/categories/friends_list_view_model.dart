import 'package:final_thesis_app/app/typedefs/e_chat_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/domain/chat.dart';
import '../../../../data/domain/user.dart';
import '../../../../app/services/providers.dart';

part 'friends_list_view_model.g.dart';

@riverpod
class FriendsListViewModel extends _$FriendsListViewModel {
  @override
  Future<(User, List<User>)> build({List<User>? preloadedFriends}) async {
    final userService = ref.watch(userServiceProvider);

    final user = await userService.getCurrentUser();
    if (user == null) {
      throw Exception("Failed to get current user");
    }

    if (preloadedFriends != null && preloadedFriends.isNotEmpty) {
      return (user, preloadedFriends);
    }

    final friends = await userService.getUsersFriends(user);
    return (user, friends ?? []);
  }

  Future<Chat> getDirectChat(User currentUser, User friend) async {
    final chatService = ref.watch(chatServiceProvider);
    var chat = await chatService.getDirectChat(currentUser.id!, friend.id!);
    if (chat == null) {
      final users = [currentUser.id!, friend.id!]..sort((a,b) => a.compareTo(b));
      chat = Chat(
        name: 'Direct chat with ${friend.firstName} ${friend.lastName}',
        participants: [currentUser.id!, friend.id!],
        fastSearchKey: users.join("_"),
        type: EChatType.direct,
      );

      final success = await chatService.saveOrUpdateChat(chat);
      if (!success) {
        throw Exception("Failed to create chat!");
      }

      var savedChat = await chatService.getDirectChat(currentUser.id!, friend.id!);
      if (savedChat == null) {
        throw Exception("Failed to get created chat!");
      }
      chat = savedChat;
    }
    return chat;
  }
}
