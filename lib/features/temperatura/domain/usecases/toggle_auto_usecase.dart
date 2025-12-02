import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/temperatura/domain/repositories/temp_repository.dart';

class ToggleAutoUsecase {
  final TempRepository repo;
  ToggleAutoUsecase(this.repo);

  Future<Result<void>> call({required String ip, required bool enabled}) =>
      repo.toggleAuto(ip: ip, enabled: enabled);
}
