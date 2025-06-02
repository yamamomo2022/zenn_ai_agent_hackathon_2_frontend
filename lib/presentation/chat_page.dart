import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import "dart:math";
import '../services/theme_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title, required this.themeService});
  final String title;
  final ThemeService themeService;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = InMemoryChatController();

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
              _chatController.setMessages([]);
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: Chat(
        chatController: _chatController,
        currentUserId: 'user1',
        onMessageSend: (text) {
          _chatController.insertMessage(
            TextMessage(
              id: '${Random().nextInt(1000) + 1}',
              authorId: 'user1',
              createdAt: DateTime.now().toUtc(),
              text: text,
            ),
          );

          _chatController.insertMessage(
            TextMessage(
              id: '${Random().nextInt(1000) + 1000}',
              authorId: 'echo_bot',
              createdAt: DateTime.now().toUtc(),
              text: text,
            ),
          );
        },
        resolveUser: (UserID id) async {
          if (id == 'echo_bot') {
            return User(id: id, name: 'Echo Bot');
          }
          return User(id: id, name: 'John Doe');
        },
      ),
    );
  }
}
