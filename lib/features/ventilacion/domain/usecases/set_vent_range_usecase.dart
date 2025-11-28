import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';

class SetVentRangeUsecase {
  final VentRepository repo;
  SetVentRangeUsecase(this.repo);

  Future<Result<void>> call(String ip, double min, double max) =>
      repo.setRange(ip, min, max);
}
