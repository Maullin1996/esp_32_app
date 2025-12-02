// lib/features/mq2/domain/usecases/set_mq2_alarm_manual_usecase.dart

import 'package:esp32_app/core/utils/result.dart';
import '../repositories/mq2_repository.dart';

class SetMq2AlarmManualUsecase {
  final Mq2Repository repo;
  SetMq2AlarmManualUsecase(this.repo);

  Future<Result<void>> call(String ip, bool on) => repo.setAlarmManual(ip, on);
}
