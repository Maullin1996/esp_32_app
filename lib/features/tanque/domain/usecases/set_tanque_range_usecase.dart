import '../../../../core/utils/result.dart';
import '../repositories/tanque_repository.dart';

class SetTanqueRangeUsecase {
  final TanqueRepository repo;
  SetTanqueRangeUsecase(this.repo);

  Future<Result<void>> call({
    required String ip,
    required double min,
    required double max,
  }) => repo.setRange(ip: ip, min: min, max: max);
}
