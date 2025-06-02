import '../entities/chat_message.dart';
import '../entities/chat_user.dart';
import '../value_objects/user_id.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getMessages();
  Future<void> sendMessage(ChatMessage message);
  Future<void> clearMessages();
  Future<ChatUser> resolveUser(UserId userId);
}
