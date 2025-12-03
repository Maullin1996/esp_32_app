import 'package:http/http.dart' as http;
import 'package:esp32_app/core/network/http_client.dart';

class PersianaRemoteDatasource {
  final HttpClient client;

  PersianaRemoteDatasource(this.client);

  Uri _u(String ip, String path, [Map<String, String>? q]) =>
      Uri.http(ip, path, q);

  Future<http.Response> getStatus(String ip) => client.get(_u(ip, "/status"));

  Future<http.Response> setRange(String ip, double min, double max) =>
      client.post(
        _u(ip, "/set_range", {"min": min.toString(), "max": max.toString()}),
      );

  Future<http.Response> setPwm(String ip, int pwm) =>
      client.post(_u(ip, "/set_pwm", {"pwm": pwm.toString()}));

  Future<http.Response> setTiming(String ip, int openMs, int closeMs) =>
      client.post(
        _u(ip, "/set_time", {
          "open": openMs.toString(),
          "close": closeMs.toString(),
        }),
      );

  Future<http.Response> autoOn(String ip) => client.post(_u(ip, "/auto_on"));

  Future<http.Response> autoOff(String ip) => client.post(_u(ip, "/auto_off"));

  Future<http.Response> manualStart(String ip, String direction) => client.post(
    _u(ip, "/manual_start", {
      "action": direction, // "open" o "close"
    }),
  );

  Future<http.Response> manualStop(String ip) =>
      client.post(_u(ip, "/manual_stop"));
}
