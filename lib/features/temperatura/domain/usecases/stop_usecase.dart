import '../../../../core/utils/result.dart';
import '../repositories/temp_repository.dart';

class StopUsecase {
  final TempRepository repo;
  StopUsecase(this.repo);

  Future<Result<void>> call(String ip) => repo.stop(ip);
}
