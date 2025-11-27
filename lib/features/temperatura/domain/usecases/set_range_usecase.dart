import '../../../../core/utils/result.dart';
import '../repositories/temp_repository.dart';

class SetRangeUsecase {
  final TempRepository repo;
  SetRangeUsecase(this.repo);

  Future<Result<void>> call({
    required String ip,
    required double min,
    required double max,
  }) => repo.setRange(ip: ip, min: min, max: max);
}
