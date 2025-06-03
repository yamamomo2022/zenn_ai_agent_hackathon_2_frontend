import 'package:flutter_chat_core/flutter_chat_core.dart';
import '../value_objects/user_id.dart';

class ChatUser {
  final UserId id;
  final String name;

  const ChatUser({required this.id, required this.name});

  User toFlutterChatCore() {
    return User(id: id.value, name: name);
  }

  static ChatUser fromFlutterChatCore(User user) {
    return ChatUser(id: UserId(user.id), name: user.name ?? 'Unknown User');
  }
}
