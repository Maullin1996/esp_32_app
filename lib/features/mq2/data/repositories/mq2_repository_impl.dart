// lib/features/mq2/data/repositories/mq2_repository_impl.dart

import 'dart:convert';

import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/mq2/domain/entities/mq2_state.dart';
import 'package:esp32_app/features/mq2/domain/repositories/mq2_repository.dart';

import '../datasources/mq2_remote_datasource.dart';

class Mq2RepositoryImpl implements Mq2Repository {
  final Mq2RemoteDatasource remote;
  Mq2RepositoryImpl(this.remote);

  @override
  Future<Result<Mq2State>> getStatus(String ip) async {
    try {
      final r = await remote.getStatus(ip).timeout(const Duration(seconds: 2));

      if (r.statusCode != 200) {
        return Failure("HTTP ${r.statusCode}");
      }

      final json = jsonDecode(r.body) as Map<String, dynamic>;

      final ppm = (json["ppm"] ?? 0) as int;
      final autoFlag = (json["auto"] ?? 0) as int;
      final alarmFlag = (json["alarm"] ?? 0) as int;
      final lowTh = (json["low_th"] ?? 200) as int;
      final highTh = (json["high_th"] ?? 500) as int;
      final sensingFlag = (json["sensing"] ?? 1) as int;

      return Success(
        Mq2State(
          espIp: ip,
          ppm: ppm,
          autoOn: autoFlag == 1,
          alarmOn: alarmFlag == 1,
          lowTh: lowTh,
          highTh: highTh,
          sensingOn: sensingFlag == 1,
        ),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setAuto(String ip, bool enable) async {
    try {
      final r = await (enable ? remote.setAutoOn(ip) : remote.setAutoOff(ip))
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setThresholds(String ip, int low, int high) async {
    try {
      final r = await remote
          .setThresholds(ip, low, high)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setAlarmManual(String ip, bool on) async {
    try {
      final r = await remote
          .setAlarmManual(ip, on)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setSensing(String ip, bool enable) async {
    try {
      final r = await remote
          .setSensing(ip, enable)
          .timeout(const Duration(seconds: 2));

      return r.statusCode == 200
          ? const Success(null)
          : Failure("HTTP ${r.statusCode}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
