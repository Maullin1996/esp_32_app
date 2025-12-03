import 'package:http/http.dart' as http;

import '../../../../core/network/http_client.dart';

class HumedadRemoteDatasource {
  final HttpClient client;
  HumedadRemoteDatasource(this.client);

  Uri _uri(String ip, String path, [Map<String, String>? query]) {
    return Uri.http(ip, path, query);
  }

  Future<http.Response> getStatus(String ip) => client.get(_uri(ip, "/status"));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _uri(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> stop(String ip) => client.post(_uri(ip, "/stop"));

  Future<http.Response> manualPump(String ip, bool state) =>
      client.post(_uri(ip, "/manual_pump", {"state": state ? "1" : "0"}));
}
