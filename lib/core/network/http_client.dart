import 'package:http/http.dart' as http;

class HttpClient {
  final http.Client _client;
  HttpClient(this._client);

  Future<http.Response> get(Uri uri) => _client.get(uri);

  Future<http.Response> post(Uri uri, {Object? body}) =>
      _client.post(uri, body: body);
}
