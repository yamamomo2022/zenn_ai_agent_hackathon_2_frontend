import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/services/echo_bot_service.dart';
import '../../domain/services/message_id_generator.dart';
import '../../domain/value_objects/user_id.dart';

class SendMessageUseCase {
  final ChatRepository _chatRepository;
  final EchoBotService _echoBotService;
  final MessageIdGenerator _messageIdGenerator;

  SendMessageUseCase(
    this._chatRepository,
    this._echoBotService,
    this._messageIdGenerator,
  );

  Future<void> execute(String text, UserId currentUserId) async {
    final userMessage = ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: currentUserId,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );

    await _chatRepository.sendMessage(userMessage);

    final echoMessage = _echoBotService.createEchoMessage(userMessage);
    await _chatRepository.sendMessage(echoMessage);
  }
}
