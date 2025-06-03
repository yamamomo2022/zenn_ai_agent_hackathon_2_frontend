import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository _chatRepository;

  GetMessagesUseCase(this._chatRepository);

  Stream<List<ChatMessage>> execute() {
    return _chatRepository.getMessages();
  }
}
