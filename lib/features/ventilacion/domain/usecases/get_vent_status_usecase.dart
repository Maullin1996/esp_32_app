import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/ventilacion/domain/entities/vent_state.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';

class GetVentStatusUsecase {
  final VentRepository repo;
  GetVentStatusUsecase(this.repo);

  Future<Result<VentState>> call(String ip) => repo.getStatus(ip);
}
