import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/domain/entities/door_state.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';

class GetDoorStatusUsecase {
  final DoorRepository repo;
  GetDoorStatusUsecase(this.repo);

  Future<Result<DoorState>> call(String ip) => repo.getStatus(ip);
}
