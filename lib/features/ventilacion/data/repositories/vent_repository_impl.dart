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

      final tempsJson = (json["temps"] as List?) ?? [];
      final fansJson = (json["fans"] as List?) ?? [];

      final temps = tempsJson.map((e) => (e as num).toDouble()).toList();
      final fans = fansJson.map((e) => (e as num) == 1).toList();

      return Success(
        VentState(
          espIp: ip,
          temps: temps,
          rangeMin: (json["range_min"] ?? 24).toDouble(),
          rangeMax: (json["range_max"] ?? 28).toDouble(),
          fans: fans,
          autoEnabled: json["auto"] == 1,
        ),
      );
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
  Future<Result<void>> setFanManual(String ip, int id, bool on) async {
    try {
      final r = await remote
          .fanManual(ip, id, on)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
