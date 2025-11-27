import 'package:http/http.dart' as http;

import '../../../../core/network/endpoints.dart';
import '../../../../core/network/http_client.dart';

class LucesRemoteDatasource {
  final HttpClient client;
  LucesRemoteDatasource(this.client);

  Uri _uri(String ip, String path, [Map<String, String>? query]) {
    return Uri.http(ip, path, query);
  }

  Future<http.Response> setRelay({
    required String ip,
    required int id,
    required bool state,
  }) {
    return client.post(
      _uri(ip, Endpoints.relay, {
        'id': id.toString(),
        'state': state ? '1' : '0',
      }),
    );
  }

  Future<http.Response> setRelays({
    required String ip,
    required List<bool> states,
  }) {
    final body = states.map((e) => e ? '1' : '0').join(',');
    return client.post(_uri(ip, Endpoints.relays), body: body);
  }
}
