import 'dart:convert';

import '../../../../core/utils/result.dart';
import '../../domain/entities/temp_state.dart';
import '../../domain/repositories/temp_repository.dart';
import '../datasources/temp_remote_datasource.dart';

class TempRepositoryImpl implements TempRepository {
  final TempRemoteDatasource remote;
  TempRepositoryImpl(this.remote);

  @override
  Future<Result<TempState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));
      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body);

      return Success(
        TempState(
          espIp: ip,
          temperature: (json["temperature"] ?? 0).toDouble(),
          mode: json["mode"] ?? "off",
          manualTarget: (json["target"] ?? 40).toDouble(),
          rangeMin: (json["range_min"] ?? 30).toDouble(),
          rangeMax: (json["range_max"] ?? 35).toDouble(),
          heaterOn: json["heater"] == 1,
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
