import '../../domain/entities/chat_message.dart';
import '../../domain/services/echo_bot_service.dart';
import '../../domain/services/message_id_generator.dart';
import '../../domain/value_objects/user_id.dart';

class SimpleEchoBotService implements EchoBotService {
  final MessageIdGenerator _messageIdGenerator;

  SimpleEchoBotService(this._messageIdGenerator);

  @override
  ChatMessage createEchoMessage(ChatMessage originalMessage) {
    return ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: const UserId('echo_bot'),
      createdAt: DateTime.now().toUtc(),
      text: originalMessage.text,
    );
  }
}
