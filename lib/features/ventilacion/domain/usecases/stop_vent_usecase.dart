import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';

class StopVentUsecase {
  final VentRepository repo;
  StopVentUsecase(this.repo);

  Future<Result<void>> call(String ip) => repo.stop(ip);
}
