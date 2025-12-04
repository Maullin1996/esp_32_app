import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';

class SetDoorAutoUsecase {
  final DoorRepository repo;
  SetDoorAutoUsecase(this.repo);

  Future<Result<void>> call(String ip, bool enabled) =>
      repo.setAuto(ip, enabled);
}
