// lib/features/mq2/domain/usecases/set_mq2_sensing_usecase.dart

import 'package:esp32_app/core/utils/result.dart';
import '../repositories/mq2_repository.dart';

class SetMq2SensingUsecase {
  final Mq2Repository repo;
  SetMq2SensingUsecase(this.repo);

  Future<Result<void>> call(String ip, bool enable) =>
      repo.setSensing(ip, enable);
}
