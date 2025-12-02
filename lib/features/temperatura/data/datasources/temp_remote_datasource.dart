import 'package:esp32_app/core/network/http_client.dart';
import 'package:http/http.dart' as http;

class TempRemoteDatasource {
  final HttpClient client;
  TempRemoteDatasource(this.client);

  Uri _uri(String ip, String path, [Map<String, String>? query]) {
    return Uri.http(ip, path, query);
  }

  Future<http.Response> getStatus(String ip) => client.get(_uri(ip, "/status"));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _uri(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> toggleAuto(String ip, bool enabled) =>
      client.post(_uri(ip, "/auto", {"enabled": enabled ? "1" : "0"}));

  Future<http.Response> forceOff(String ip) =>
      client.post(_uri(ip, "/force_off"));
}
