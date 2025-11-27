import '../../../../core/utils/result.dart';
import '../entities/humedad_state.dart';
import '../repositories/humedad_repository.dart';

class GetHumedadStatusUsecase {
  final HumedadRepository repo;
  GetHumedadStatusUsecase(this.repo);

  Future<Result<HumedadState>> call(String ip) => repo.getStatus(ip);
}
