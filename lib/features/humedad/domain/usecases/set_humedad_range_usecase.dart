import '../../../../core/utils/result.dart';
import '../repositories/humedad_repository.dart';

class SetHumedadRangeUsecase {
  final HumedadRepository repo;
  SetHumedadRangeUsecase(this.repo);

  Future<Result<void>> call({
    required String ip,
    required double min,
    required double max,
  }) => repo.setRange(ip: ip, min: min, max: max);
}
