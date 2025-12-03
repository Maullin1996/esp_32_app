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
      final r = await remote.getStatus(ip);

      final json = jsonDecode(r.body);
      return Success(
        HumedadState(
          espIp: ip,
          humidity: (json["humidity"] ?? 0).toDouble(),
          autoEnabled: json["auto_enabled"] == 1,
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
  Future<Result<void>> setRange({
    required ip,
    required min,
    required max,
  }) async {
    try {
      final r = await remote.setRange(ip, min, max);
      return r.statusCode == 200 ? const Success(null) : Failure("HTTP error");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> stop(String ip) async {
    try {
      final r = await remote.stop(ip);
      return r.statusCode == 200 ? const Success(null) : Failure("HTTP error");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> manualPump(String ip, bool state) async {
    try {
      final r = await remote.manualPump(ip, state);
      return r.statusCode == 200 ? const Success(null) : Failure("HTTP error");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
