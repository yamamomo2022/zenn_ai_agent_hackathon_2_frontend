import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../infrastructure/services/firebase_functions_service.dart';
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
  late final FirebaseFunctionsService _firebaseFunctionsService;
  final TextEditingController _textController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firebaseFunctionsService = serviceLocator<FirebaseFunctionsService>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _imageBytes = null;
    });

    try {
      // 画像生成Cloud Functionを呼び出し
      final imageData = await _firebaseFunctionsService.callImageGeneration(
        text,
      );

      setState(() {
        // base64画像データをバイト配列に変換
        final base64Image = imageData['base64Image']!;
        _imageBytes = base64Decode(base64Image);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
      _textController.clear();
    }
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 画像表示エリア
            Expanded(
              child: _imageBytes == null
                  ? const Center(
                      child: Text(
                        '生成衛星画像',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Image.memory(
                      _imageBytes!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            '画像の読み込みに失敗しました',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            // テキストフィールドと送信ボタン
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '建物や地名を入力してください',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('送信'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
