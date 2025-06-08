import 'package:flutter_test/flutter_test.dart';
import 'package:zenn_ai_agent_hackathon_2_frontend/domain/entities/chat_message.dart';
import 'package:zenn_ai_agent_hackathon_2_frontend/domain/value_objects/user_id.dart';
import 'package:zenn_ai_agent_hackathon_2_frontend/domain/value_objects/message_id.dart';
import 'package:zenn_ai_agent_hackathon_2_frontend/infrastructure/services/simple_echo_bot_service.dart';
import 'package:zenn_ai_agent_hackathon_2_frontend/domain/services/message_id_generator.dart';

class DummyMessageIdGenerator implements MessageIdGenerator {
  int _counter = 0;
  @override
  MessageId generate() => MessageId('dummy-${_counter++}');
}

void main() {
  group('EchoBotService', () {
    test('createEchoMessage returns a message with the same text as input', () {
      final echoBot = SimpleEchoBotService(DummyMessageIdGenerator());
      final userMessage = ChatMessage(
        id: MessageId('1'),
        authorId: UserId('user1'),
        createdAt: DateTime.now(),
        text: 'Hello, world!',
      );
      final echoMessage = echoBot.createEchoMessage(userMessage);
      expect(echoMessage.text, contains('Hello, world!'));
      expect(echoMessage.authorId.value, isNot(userMessage.authorId.value));
      expect(echoMessage.id, isNot(userMessage.id));
    });
  });
}
