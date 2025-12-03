import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class SetPersianaRangeUsecase {
  final PersianaRepository repo;
  SetPersianaRangeUsecase(this.repo);

  Future<Result<void>> call(String ip, double min, double max) =>
      repo.setRange(ip, min, max);
}
