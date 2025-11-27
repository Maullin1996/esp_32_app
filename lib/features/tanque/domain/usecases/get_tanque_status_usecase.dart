import '../../../../core/utils/result.dart';
import '../entities/tanque_state.dart';
import '../repositories/tanque_repository.dart';

class GetTanqueStatusUsecase {
  final TanqueRepository repo;
  GetTanqueStatusUsecase(this.repo);

  Future<Result<TanqueState>> call(String ip) => repo.getStatus(ip);
}
