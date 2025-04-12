import 'package:final_thesis_app/data/repositories/message/message_storage.dart';
import 'package:final_thesis_app/data/repositories/repository.dart';

import '../../../data/domain/message.dart';
import '../../typedefs/entity.dart';

class MessageService {
  final MessageStorage _messageStorage;
  MessageService(this._messageStorage);

  Future<bool> saveOrUpdateMessage(MessagePayload payload) async {
    final result = await _messageStorage.saveOrUpdateMessage(payload);
    return result;
  }

  Future<List<MessagePayload>?> getMessagesByChatId(String chatId) async {
    final payloads = await _messageStorage.getMessagesByChatId(chatId);
    return payloads;
  }

  Stream<List<MessagePayload>?> listenToChatMessages(String chatId) {
    return _messageStorage.listenToChatMessages(chatId);
  }

  Future<bool> deleteMessageByIds(Id chatId, Id messageId) async {
    return await _messageStorage.deleteMessageByIds(chatId, messageId);
  }

  Future<bool> deleteMessage(Message message) async {
    return await _messageStorage.deleteMessage(MessagePayload().messageToMessagePayload(message));
  }

}