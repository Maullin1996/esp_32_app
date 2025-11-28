import '../../domain/entities/vent_state.dart';
import '../../domain/repositories/vent_repository.dart';
import '../../../../core/utils/result.dart';
import '../datasources/vent_remote_datasource.dart';
import 'dart:convert';

class VentRepositoryImpl implements VentRepository {
  final VentRemoteDatasource remote;
  VentRepositoryImpl(this.remote);

  @override
  Future<Result<VentState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));
      if (r.statusCode != 200) return Failure("HTTP ${r.statusCode}");

      final json = jsonDecode(r.body);

      return Success(
        VentState(
          espIp: ip,
          temperature: (json["temperature"] ?? 0).toDouble(),
          mode: json["mode"] ?? "off",
          manualTarget: (json["target"] ?? 28).toDouble(),
          rangeMin: (json["range_min"] ?? 24).toDouble(),
          rangeMax: (json["range_max"] ?? 28).toDouble(),
          fanOn: json["fan"] == 1,
        ),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setManual(String ip, double target) async {
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
