import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';

enum DoorManualAction { open, close, stop }

class DoorManualActionUsecase {
  final DoorRepository repo;
  DoorManualActionUsecase(this.repo);

  Future<Result<void>> call(String ip, DoorManualAction action) {
    switch (action) {
      case DoorManualAction.open:
        return repo.manualOpen(ip);
      case DoorManualAction.close:
        return repo.manualClose(ip);
      case DoorManualAction.stop:
        return repo.manualStop(ip);
    }
  }
}
