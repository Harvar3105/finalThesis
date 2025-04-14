import 'package:final_thesis_app/data/domain/chat.dart';
import 'package:final_thesis_app/data/repositories/chat/chat_storage.dart';

import '../../typedefs/entity.dart';

class ChatService {
  final ChatStorage _chatStorage;
  ChatService(this._chatStorage);

  Future<bool> saveOrUpdateChat(Chat chat) async {
    final result = await _chatStorage.saveOrUpdateChat(ChatPayload().chatToChatPayload(chat));
    return result;
  }

  Future<List<Chat>?> getAllChats() async {
    final payloads = await _chatStorage.getAllChats();
    return payloads?.map((payload) => payload.chatFromPayload()).whereType<Chat>().toList();
  }

  Future<Chat?> getChatById(Id id) async {
    final payload = await _chatStorage.getChatById(id);
    return payload?.chatFromPayload();
  }

  Future<List<Chat>?> getChatsByUserId(Id id) async {
    final payloads = await _chatStorage.getChatsByUserId(id);
    return payloads?.map((payload) => payload.chatFromPayload()).whereType<Chat>().toList();
  }

  Future<Chat?> getDirectChat(Id firstUserId, Id secondUserId) async {
    return (await _chatStorage.getDirectChat(firstUserId, secondUserId))?.chatFromPayload();
  }

  Future<bool> deleteChat(Chat chat) async {
    return await _chatStorage.deleteChat(ChatPayload().chatToChatPayload(chat));
  }

  Future<bool> deleteChatById(Id id) async {
    return await _chatStorage.deleteChatById(id);
  }
}