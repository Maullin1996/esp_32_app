// lib/features/mq2/domain/repositories/mq2_repository.dart

import 'package:esp32_app/core/utils/result.dart';
import '../entities/mq2_state.dart';

abstract class Mq2Repository {
  Future<Result<Mq2State>> getStatus(String ip);

  Future<Result<void>> setAuto(String ip, bool enable);

  Future<Result<void>> setThresholds(String ip, int low, int high);

  Future<Result<void>> setAlarmManual(String ip, bool on);

  Future<Result<void>> setSensing(String ip, bool enable);
}
