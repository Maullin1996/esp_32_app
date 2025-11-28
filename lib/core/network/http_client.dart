import 'package:http/http.dart' as http;

class HttpClient {
  final http.Client _client;
  HttpClient(this._client);

  Future<http.Response> get(Uri uri) async {
    return _retry(() async {
      return await _client.get(uri).timeout(const Duration(milliseconds: 1500));
    });
  }

  Future<http.Response> post(Uri uri, {Object? body}) async {
    return _retry(() async {
      return await _client
          .post(uri, body: body)
          .timeout(const Duration(milliseconds: 1500));
    });
  }

  Future<T> _retry<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 200));
      return await request();
    }
  }
}
