import 'dart:convert';

import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/temperatura/data/datasources/temp_remote_datasource.dart';
import 'package:esp32_app/features/temperatura/domain/entities/temp_state.dart';
import 'package:esp32_app/features/temperatura/domain/repositories/temp_repository.dart';

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

      final json = jsonDecode(r.body) as Map<String, dynamic>;

      return Success(
        TempState(
          espIp: ip,
          temperature: (json["temperature"] as num?)?.toDouble() ?? 0.0,
          rangeMin: (json["range_min"] as num?)?.toDouble() ?? 30.0,
          rangeMax: (json["range_max"] as num?)?.toDouble() ?? 35.0,
          autoEnabled: (json["auto"] ?? 0) == 1,
          forcedOff: (json["forced_off"] ?? 0) == 1,
          heaterOn: (json["heater"] ?? 0) == 1,
        ),
      );
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
  Future<Result<void>> toggleAuto({
    required String ip,
    required bool enabled,
  }) async {
    try {
      final r = await remote
          .toggleAuto(ip, enabled)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> forceOff(String ip) async {
    try {
      final r = await remote.forceOff(ip).timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
