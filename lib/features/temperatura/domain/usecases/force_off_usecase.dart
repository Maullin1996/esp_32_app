import '../../../../core/utils/result.dart';
import '../repositories/temp_repository.dart';

class ForceOffUsecase {
  final TempRepository repo;
  ForceOffUsecase(this.repo);

  Future<Result<void>> call(String ip) => repo.forceOff(ip);
}
