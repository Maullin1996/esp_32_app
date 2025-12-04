import 'package:esp32_app/core/network/http_client.dart';
import 'package:http/http.dart' as http;

class DoorRemoteDatasource {
  final HttpClient client;
  DoorRemoteDatasource(this.client);

  Uri _u(String ip, String path, [Map<String, String>? q]) =>
      Uri.http(ip, path, q);

  Future<http.Response> getStatus(String ip) =>
      client.get(_u(ip, "/door/status"));

  Future<http.Response> setThreshold(String ip, int threshold) => client.post(
    _u(ip, "/door/set_lux_threshold", {"lux": threshold.toString()}),
  );

  Future<http.Response> autoOn(String ip) =>
      client.post(_u(ip, "/door/auto_on"));

  Future<http.Response> autoOff(String ip) =>
      client.post(_u(ip, "/door/auto_off"));

  Future<http.Response> open(String ip) => client.post(_u(ip, "/door/open"));

  Future<http.Response> close(String ip) => client.post(_u(ip, "/door/close"));

  Future<http.Response> stop(String ip) => client.post(_u(ip, "/door/stop"));
}
