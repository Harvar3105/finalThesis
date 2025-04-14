import 'package:final_thesis_app/data/repositories/message/message_storage.dart';

import '../../../data/domain/message.dart';
import '../../typedefs/entity.dart';

class MessageService {
  final MessageStorage _messageStorage;
  MessageService(this._messageStorage);

  Future<bool> saveOrUpdateMessage(MessagePayload payload) async {
    final result = await _messageStorage.saveOrUpdateMessage(payload);
    return result;
  }

  Future<List<Message>?> getMessagesByChatId(String chatId) async {
    return (await _messageStorage.getMessagesByChatId(chatId))
      ?.map((entity) => entity.messageFromPayload())
      .cast<Message>()
      .whereType<Message>()
      .toList();
  }

  Stream<List<Message>?> listenToChatMessages(String chatId) {
    return _messageStorage.listenToChatMessages(chatId).map(
          (payloads) => payloads?.map((p) => p.messageFromPayload()).whereType<Message>().toList(),
    );
  }

  Future<bool> deleteMessageByIds(Id chatId, Id messageId) async {
    return await _messageStorage.deleteMessageByIds(chatId, messageId);
  }

  Future<bool> deleteMessage(Message message) async {
    return await _messageStorage.deleteMessage(MessagePayload().messageToMessagePayload(message));
  }

  Future<Message?> getLastChatMessage(Id chatId) async {
    return (await _messageStorage.getLastChatMessage(chatId))?.messageFromPayload();
  }

}