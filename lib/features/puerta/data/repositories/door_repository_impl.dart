import 'dart:convert';

import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/data/datasources/door_remote_datasource.dart';
import 'package:esp32_app/features/puerta/domain/entities/door_state.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';

class DoorRepositoryImpl implements DoorRepository {
  final DoorRemoteDatasource remote;
  DoorRepositoryImpl(this.remote);

  @override
  Future<Result<DoorState>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));

      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body) as Map<String, dynamic>;

      final state = DoorState(
        espIp: ip,
        lux: (json["lux"] ?? 0).toDouble(),
        threshold: (json["threshold"] ?? 40) as int,
        state: json["state"]?.toString() ?? "idle",
        autoEnabled: (json["auto"] ?? 0) == 1,
        fullyOpen: (json["fully_open"] ?? 0) == 1,
        fullyClosed: (json["fully_closed"] ?? 0) == 1,
      );

      return Success(state);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setThreshold(String ip, int threshold) async {
    try {
      final r = await remote
          .setThreshold(ip, threshold)
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
  Future<Result<void>> manualOpen(String ip) async {
    try {
      final r = await remote.open(ip).timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> manualClose(String ip) async {
    try {
      final r = await remote.close(ip).timeout(const Duration(seconds: 2));

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
      final r = await remote.stop(ip).timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
