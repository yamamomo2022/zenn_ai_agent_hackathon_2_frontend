import '../../domain/repositories/chat_repository.dart';

class ResetChatUseCase {
  final ChatRepository _chatRepository;

  ResetChatUseCase(this._chatRepository);

  Future<void> execute() async {
    await _chatRepository.clearMessages();
  }
}
