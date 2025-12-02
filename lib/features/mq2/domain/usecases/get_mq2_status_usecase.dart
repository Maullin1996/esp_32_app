// lib/features/mq2/domain/usecases/get_mq2_status_usecase.dart

import 'package:esp32_app/core/utils/result.dart';
import '../entities/mq2_state.dart';
import '../repositories/mq2_repository.dart';

class GetMq2StatusUsecase {
  final Mq2Repository repo;
  GetMq2StatusUsecase(this.repo);

  Future<Result<Mq2State>> call(String ip) => repo.getStatus(ip);
}
