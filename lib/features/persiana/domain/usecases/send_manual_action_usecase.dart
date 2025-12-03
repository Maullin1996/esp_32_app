import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

enum PersianaManualAction { open, close, stop }

class SendManualActionUsecase {
  final PersianaRepository repo;
  SendManualActionUsecase(this.repo);

  Future<Result<void>> call(String ip, PersianaManualAction action) {
    switch (action) {
      case PersianaManualAction.open:
        return repo.manualStart(ip, "open");
      case PersianaManualAction.close:
        return repo.manualStart(ip, "close");
      case PersianaManualAction.stop:
        return repo.manualStop(ip);
    }
  }
}
