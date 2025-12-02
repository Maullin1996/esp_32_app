// lib/features/mq2/domain/usecases/set_mq2_auto_usecase.dart

import 'package:esp32_app/core/utils/result.dart';
import '../repositories/mq2_repository.dart';

class SetMq2AutoUsecase {
  final Mq2Repository repo;
  SetMq2AutoUsecase(this.repo);

  Future<Result<void>> call(String ip, bool enable) => repo.setAuto(ip, enable);
}
