import '../../../../core/utils/result.dart';
import '../repositories/humedad_repository.dart';

class StopHumedadUsecase {
  final HumedadRepository repo;
  StopHumedadUsecase(this.repo);

  Future<Result<void>> call(String ip) => repo.stop(ip);
}
