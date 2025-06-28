import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-northeast1',
  );

  Future<String> callHelloGenkit(String text) async {
    try {
      final result = await _functions.httpsCallable('helloGenkit').call({
        'text': text,
      });
      return result.data['text'] as String;
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Cloud Function error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // 生成画像のbase64を取得し、デコードして返すメソッド
  Future<Map<String, String>> callImageGeneration(String prompt) async {
    try {
      final result = await _functions.httpsCallable('GenerateImagen').call({
        'prompt': prompt,
      });

      final data = result.data;
      return {
        'base64Image': data['base64Image'] as String,
        'mimeType': data['mimeType'] as String,
      };
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Cloud Function error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<String> callGeocoding(String address) async {
    try {
      final result = await _functions.httpsCallable('Geocoding').call({
        'locationName': address,
      });
      // Cloud Functions から返ってくる値は { latitude, longitude } の Map なので、
      // それをテキスト形式（例: "lat,lon"）で返す
      final data = result.data;
      final latitude = data['latitude'];
      final longitude = data['longitude'];
      return '$latitude,$longitude';
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Cloud Function error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
