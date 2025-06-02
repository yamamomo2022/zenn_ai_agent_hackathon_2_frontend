import 'dart:async';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_user.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/value_objects/user_id.dart';

class InMemoryChatRepository implements ChatRepository {
  final InMemoryChatController _controller;
  final StreamController<List<ChatMessage>> _messagesController;

  InMemoryChatRepository()
      : _controller = InMemoryChatController(),
        _messagesController = StreamController<List<ChatMessage>>.broadcast() {
    _controller.operationsStream.listen((_) {
      final messages = _controller.messages
          .map((message) => ChatMessage.fromFlutterChatCore(message as TextMessage))
          .toList();
      _messagesController.add(messages);
    });
  }

  @override
  Stream<List<ChatMessage>> getMessages() {
    return _messagesController.stream;
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    _controller.insertMessage(message.toFlutterChatCore());
  }

  @override
  Future<void> clearMessages() async {
    _controller.setMessages([]);
  }

  @override
  Future<ChatUser> resolveUser(UserId userId) async {
    if (userId.value == 'echo_bot') {
      return const ChatUser(id: UserId('echo_bot'), name: 'Echo Bot');
    }
    return ChatUser(id: userId, name: 'John Doe');
  }

  void dispose() {
    _controller.dispose();
    _messagesController.close();
  }
}
