import 'dart:math';
import '../../domain/services/message_id_generator.dart';
import '../../domain/value_objects/message_id.dart';

class RandomMessageIdGenerator implements MessageIdGenerator {
  final Random _random = Random();

  @override
  MessageId generate() {
    return MessageId('${_random.nextInt(1000000)}');
  }
}
