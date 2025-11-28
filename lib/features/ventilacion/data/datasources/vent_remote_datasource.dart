import 'package:http/http.dart' as http;
import '../../../../core/network/http_client.dart';

class VentRemoteDatasource {
  final HttpClient client;
  VentRemoteDatasource(this.client);

  Uri _u(String ip, String path, [Map<String, String>? q]) =>
      Uri.http(ip, path, q);

  Future<http.Response> getStatus(String ip) => client.get(_u(ip, "/status"));

  Future<http.Response> setManual(String ip, double t) =>
      client.post(_u(ip, "/set_manual", {"target": t.toString()}));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _u(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> stop(String ip) => client.post(_u(ip, "/stop"));
}
