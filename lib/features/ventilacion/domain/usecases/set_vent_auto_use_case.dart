import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';

class SetVentAutoUsecase {
  final VentRepository repo;
  SetVentAutoUsecase(this.repo);

  Future<Result<void>> call(String ip, bool enabled) =>
      repo.setAuto(ip, enabled);
}
