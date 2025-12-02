import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';

class SetVentFanManualUsecase {
  final VentRepository repo;
  SetVentFanManualUsecase(this.repo);

  Future<Result<void>> call(String ip, bool on) => repo.setFanManual(ip, on);
}
