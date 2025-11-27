import 'package:http/http.dart' as http;

import '../../../../core/network/http_client.dart';

class HumedadRemoteDatasource {
  final HttpClient client;
  HumedadRemoteDatasource(this.client);

  Uri _uri(String ip, String path, [Map<String, String>? query]) {
    return Uri.http(ip, path, query);
  }

  Future<http.Response> getStatus(String ip) => client.get(_uri(ip, "/status"));

  Future<http.Response> setManual(String ip, double target) =>
      client.post(_uri(ip, "/set_manual", {"target": target.toString()}));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _uri(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> stop(String ip) => client.post(_uri(ip, "/stop"));
}
