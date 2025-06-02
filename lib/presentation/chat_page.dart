import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import '../application/use_cases/send_message_use_case.dart';
import '../application/use_cases/reset_chat_use_case.dart';
import '../application/use_cases/get_messages_use_case.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/value_objects/user_id.dart';
import '../infrastructure/services/theme_service.dart';
import '../infrastructure/di/service_locator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title, required this.themeService});
  final String title;
  final ThemeService themeService;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final SendMessageUseCase _sendMessageUseCase;
  late final ResetChatUseCase _resetChatUseCase;
  late final GetMessagesUseCase _getMessagesUseCase;
  late final InMemoryChatController _chatController;
  final UserId _currentUserId = const UserId('user1');

  @override
  void initState() {
    super.initState();
    _sendMessageUseCase = serviceLocator<SendMessageUseCase>();
    _resetChatUseCase = serviceLocator<ResetChatUseCase>();
    _getMessagesUseCase = serviceLocator<GetMessagesUseCase>();
    _chatController = InMemoryChatController();
    
    _getMessagesUseCase.execute().listen((messages) {
      final flutterMessages = messages.map((msg) => msg.toFlutterChatCore()).toList();
      _chatController.setMessages(flutterMessages);
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeService.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.themeService.toggleTheme();
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _resetChatUseCase.execute();
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: Chat(
        chatController: _chatController,
        currentUserId: _currentUserId.value,
        onMessageSend: (text) {
          _sendMessageUseCase.execute(text, _currentUserId);
        },
        resolveUser: (UserID id) async {
          final chatUser = await serviceLocator.get<ChatRepository>().resolveUser(UserId(id));
          return chatUser.toFlutterChatCore();
        },
      ),
    );
  }
}
