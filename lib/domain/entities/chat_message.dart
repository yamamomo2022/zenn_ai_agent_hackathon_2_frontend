import 'package:flutter_chat_core/flutter_chat_core.dart';
import '../value_objects/message_id.dart';
import '../value_objects/user_id.dart';

class ChatMessage {
  final MessageId id;
  final UserId authorId;
  final DateTime? createdAt;
  final String text;

  const ChatMessage({
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.text,
  });

  TextMessage toFlutterChatCore() {
    return TextMessage(
      id: id.value,
      authorId: authorId.value,
      createdAt: createdAt,
      text: text,
    );
  }

  static ChatMessage fromFlutterChatCore(TextMessage message) {
    return ChatMessage(
      id: MessageId(message.id),
      authorId: UserId(message.authorId),
      createdAt: message.createdAt,
      text: message.text,
    );
  }
}
