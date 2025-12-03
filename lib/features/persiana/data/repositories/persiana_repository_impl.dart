import 'dart:convert';

import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/data/datasources/persiana_remote_datasource.dart';
import 'package:esp32_app/features/persiana/domain/entities/persiana_state.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class PersianaRepositoryImpl implements PersianaRepository {
  final PersianaRemoteDatasource remote;

  PersianaRepositoryImpl(this.remote);

  @override
  Future<Result<PersianaState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));

      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body) as Map<String, dynamic>;

      final state = PersianaState(
        espIp: ip,
        temperature: (json["temperature"] ?? 0).toDouble(),
        rangeMin: (json["range_min"] ?? 24).toDouble(),
        rangeMax: (json["range_max"] ?? 28).toDouble(),
        pwm: (json["pwm"] ?? 180) as int,
        timeOpenMs: (json["time_open"] ?? 1500) as int,
        timeCloseMs: (json["time_close"] ?? 1500) as int,
        motorState: json["state"]?.toString() ?? "idle",
        lastAction: json["last_action"]?.toString() ?? "none",
        autoEnabled: (json["auto"] ?? 0) == 1,
      );

      return Success(state);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setRange(String ip, double min, double max) async {
    try {
      final r = await remote
          .setRange(ip, min, max)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setPwm(String ip, int pwm) async {
    try {
      final r = await remote
          .setPwm(ip, pwm)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setTiming(
    String ip,
    int timeOpenMs,
    int timeCloseMs,
  ) async {
    try {
      final r = await remote
          .setTiming(ip, timeOpenMs, timeCloseMs)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setAuto(String ip, bool enabled) async {
    try {
      final r = await (enabled ? remote.autoOn(ip) : remote.autoOff(ip))
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> manualStart(String ip, String direction) async {
    try {
      final r = await remote
          .manualStart(ip, direction)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> manualStop(String ip) async {
    try {
      final r = await remote.manualStop(ip).timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
