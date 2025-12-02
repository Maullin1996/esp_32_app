// lib/features/mq2/domain/usecases/set_mq2_thresholds_usecase.dart

import 'package:esp32_app/core/utils/result.dart';
import '../repositories/mq2_repository.dart';

class SetMq2ThresholdsUsecase {
  final Mq2Repository repo;
  SetMq2ThresholdsUsecase(this.repo);

  Future<Result<void>> call(String ip, int low, int high) =>
      repo.setThresholds(ip, low, high);
}
