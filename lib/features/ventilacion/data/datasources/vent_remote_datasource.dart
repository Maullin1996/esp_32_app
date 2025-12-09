import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';

class VentRemoteDatasource {
  final HttpClient client;
  VentRemoteDatasource(this.client);

  Uri _u(String ip, String path, [Map<String, String>? q]) =>
      Uri.http(ip, path, q);

  Future<http.Response> getStatus(String ip) => client.get(_u(ip, "/status"));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _u(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> autoOn(String ip) => client.post(_u(ip, "/auto_on"));

  Future<http.Response> autoOff(String ip) => client.post(_u(ip, "/auto_off"));

  Future<http.Response> fanManual(String ip, int id, bool on) => client.post(
    _u(ip, "/fan_manual", {"id": id.toString(), "state": on ? "1" : "0"}),
  );
}
