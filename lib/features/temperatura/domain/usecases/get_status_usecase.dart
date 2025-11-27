import '../../../../core/utils/result.dart';
import '../entities/temp_state.dart';
import '../repositories/temp_repository.dart';

class GetStatusUsecase {
  final TempRepository repo;
  GetStatusUsecase(this.repo);

  Future<Result<TempState>> call(String ip) => repo.getStatus(ip);
}
