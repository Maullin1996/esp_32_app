import '../../../../core/utils/result.dart';
import '../repositories/tanque_repository.dart';

class StopTanqueUsecase {
  final TanqueRepository repo;
  StopTanqueUsecase(this.repo);

  Future<Result<void>> call(String ip) => repo.stop(ip);
}
