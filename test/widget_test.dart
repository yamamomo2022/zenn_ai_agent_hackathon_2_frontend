// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zenn_ai_agent_hackathon_2_frontend/main.dart';

void main() {
  testWidgets('Chat UI loads with welcome message',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the chat UI loads with the welcome message.
    expect(find.text('こんにちは！チャットを開始しましょう。'),
        findsOneWidget);

    // Verify that the app bar shows the correct title.
    expect(find.text('Chat'), findsOneWidget);

    // Verify that the chat interface is present.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
