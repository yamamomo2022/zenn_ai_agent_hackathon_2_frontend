import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/services/message_id_generator.dart';
import '../../domain/value_objects/user_id.dart';
import '../../infrastructure/services/firebase_functions_service.dart';

class SendMessageUseCase {
  final ChatRepository _chatRepository;
  final MessageIdGenerator _messageIdGenerator;
  final FirebaseFunctionsService _firebaseFunctionsService;

  final UserId _aiUserId = UserId('ai');

  SendMessageUseCase(
    this._chatRepository,
    this._messageIdGenerator,
    this._firebaseFunctionsService,
  );

  Future<void> execute(String text, UserId currentUserId) async {
    final userMessage = ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: currentUserId,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );

    await _chatRepository.sendMessage(userMessage);

    // Call helloGenkit function via Firebase Functions
    final aiResponse = await _firebaseFunctionsService.callHelloGenkit(text);
    final aiMessage = ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: _aiUserId,
      createdAt: DateTime.now().toUtc(),
      text: aiResponse,
    );
    await _chatRepository.sendMessage(aiMessage);
  }

  Future<void> executeGeocoding(String address, UserId currentUserId) async {
    final userMessage = ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: currentUserId,
      createdAt: DateTime.now().toUtc(),
      text: address,
    );
    await _chatRepository.sendMessage(userMessage);

    // geocoding Cloud Functionを呼び出す
    final geoText = await _firebaseFunctionsService.callGeocoding(address);
    final aiMessage = ChatMessage(
      id: _messageIdGenerator.generate(),
      authorId: _aiUserId,
      createdAt: DateTime.now().toUtc(),
      text: geoText,
    );
    await _chatRepository.sendMessage(aiMessage);
  }
}
