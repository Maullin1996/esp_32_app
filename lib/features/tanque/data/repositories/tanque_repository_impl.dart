import 'dart:convert';

import '../../../../core/utils/result.dart';
import '../../domain/entities/tanque_state.dart';
import '../../domain/repositories/tanque_repository.dart';
import '../datasources/tanque_remote_datasource.dart';

class TanqueRepositoryImpl implements TanqueRepository {
  final TanqueRemoteDatasource remote;
  TanqueRepositoryImpl(this.remote);

  @override
  Future<Result<TanqueState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));
      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body);

      return Success(
        TanqueState(
          espIp: ip,
          distanceCm: (json["distance_cm"] ?? 0).toDouble(),
          level: (json["level"] ?? 0).toDouble(),
          mode: json["mode"] ?? "off",
          manualTarget: (json["manualTarget"] ?? 90).toDouble(),
          rangeMin: (json["rangeMin"] ?? 20).toDouble(),
          rangeMax: (json["rangeMax"] ?? 90).toDouble(),
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
