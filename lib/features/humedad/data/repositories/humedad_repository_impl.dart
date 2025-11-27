import 'dart:convert';

import '../../../../core/utils/result.dart';
import '../../domain/entities/humedad_state.dart';
import '../../domain/repositories/humedad_repository.dart';
import '../datasources/humedad_remote_datasource.dart';

class HumedadRepositoryImpl implements HumedadRepository {
  final HumedadRemoteDatasource remote;
  HumedadRepositoryImpl(this.remote);

  @override
  Future<Result<HumedadState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));
      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body);

      return Success(
        HumedadState(
          espIp: ip,
          humidity: (json["humidity"] ?? 0).toDouble(),
          mode: json["mode"] ?? "off",
          manualTarget: (json["target"] ?? 60).toDouble(),
          rangeMin: (json["range_min"] ?? 30).toDouble(),
          rangeMax: (json["range_max"] ?? 60).toDouble(),
          pumpOn: json["pump"] == 1,
        ),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setManual({
    required String ip,
    required double target,
  }) async {
    try {
      final r = await remote
          .setManual(ip, target)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setRange({
    required String ip,
    required double min,
    required double max,
  }) async {
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
  Future<Result<void>> stop(String ip) async {
    try {
      final r = await remote.stop(ip).timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
