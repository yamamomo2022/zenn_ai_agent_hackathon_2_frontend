import '../value_objects/message_id.dart';

abstract class MessageIdGenerator {
  MessageId generate();
}
