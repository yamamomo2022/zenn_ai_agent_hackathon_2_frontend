import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-northeast1',
  );

  Future<String> callHelloGenkit(String text) async {
    final result = await _functions.httpsCallable('helloGenkit').call({
      'text': text,
    });
    return result.data['text'] as String;
  }
}
