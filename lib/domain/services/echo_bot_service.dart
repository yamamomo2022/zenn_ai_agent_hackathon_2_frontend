import '../entities/chat_message.dart';

abstract class EchoBotService {
  ChatMessage createEchoMessage(ChatMessage originalMessage);
}
