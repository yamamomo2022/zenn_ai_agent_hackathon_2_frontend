import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ChatPage(title: 'Chat'),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final InMemoryChatController _controller;
  late final User _user;

  @override
  void initState() {
    super.initState();

    _user = const User(
      id: 'user-1',
      firstName: 'User',
    );

    _controller = InMemoryChatController();

    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = TextMessage(
      author: const User(
        id: 'bot-1',
        firstName: 'Assistant',
      ),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'welcome-message',
      text: 'こんにちは！チャットを開始しましょう。',
    );

    _controller.addMessage(welcomeMessage);
  }

  void _handleSendPressed(PartialTextMessage message) {
    final textMessage = TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    _controller.addMessage(textMessage);

    _simulateResponse(message.text);
  }

  void _simulateResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      final responseMessage = TextMessage(
        author: const User(
          id: 'bot-1',
          firstName: 'Assistant',
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'あなたのメッセージ: "$userMessage" を受信しました。',
      );

      _controller.addMessage(responseMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Chat(
        messages: _controller.messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
