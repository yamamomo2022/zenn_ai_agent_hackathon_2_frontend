import 'package:get_it/get_it.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/services/echo_bot_service.dart';
import '../../domain/services/message_id_generator.dart';
import '../../application/use_cases/send_message_use_case.dart';
import '../../application/use_cases/reset_chat_use_case.dart';
import '../../application/use_cases/get_messages_use_case.dart';
import '../repositories/in_memory_chat_repository.dart';
import '../services/random_message_id_generator.dart';
import '../services/simple_echo_bot_service.dart';
import '../services/theme_service.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<MessageIdGenerator>(
    RandomMessageIdGenerator(),
  );

  serviceLocator.registerSingleton<EchoBotService>(
    SimpleEchoBotService(serviceLocator<MessageIdGenerator>()),
  );

  serviceLocator.registerSingleton<ChatRepository>(InMemoryChatRepository());

  serviceLocator.registerSingleton<ThemeService>(ThemeService());

  serviceLocator.registerFactory<SendMessageUseCase>(
    () => SendMessageUseCase(
      serviceLocator<ChatRepository>(),
      serviceLocator<EchoBotService>(),
      serviceLocator<MessageIdGenerator>(),
    ),
  );

  serviceLocator.registerFactory<ResetChatUseCase>(
    () => ResetChatUseCase(serviceLocator<ChatRepository>()),
  );

  serviceLocator.registerFactory<GetMessagesUseCase>(
    () => GetMessagesUseCase(serviceLocator<ChatRepository>()),
  );
}
