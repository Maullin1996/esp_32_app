// lib/features/mq2/data/datasources/mq2_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:esp32_app/core/network/http_client.dart';

class Mq2RemoteDatasource {
  final HttpClient client;
  Mq2RemoteDatasource(this.client);

  Uri _u(String ip, String path, [Map<String, String>? q]) =>
      Uri.http(ip, path, q);

  Future<http.Response> getStatus(String ip) => client.get(_u(ip, "/status"));

  Future<http.Response> setAutoOn(String ip) => client.post(_u(ip, "/auto_on"));

  Future<http.Response> setAutoOff(String ip) =>
      client.post(_u(ip, "/auto_off"));

  Future<http.Response> setThresholds(String ip, int low, int high) =>
      client.post(
        _u(ip, "/set_thresholds", {
          "low": low.toString(),
          "high": high.toString(),
        }),
      );

  Future<http.Response> setAlarmManual(String ip, bool on) =>
      client.post(_u(ip, "/alarm_manual", {"state": on ? "1" : "0"}));

  Future<http.Response> setSensing(String ip, bool enable) =>
      client.post(_u(ip, enable ? "/sensing_on" : "/sensing_off"));

  Map<String, dynamic> decodeJson(http.Response r) {
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
