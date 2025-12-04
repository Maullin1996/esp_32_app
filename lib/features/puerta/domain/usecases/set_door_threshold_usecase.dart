import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';

class SetDoorThresholdUsecase {
  final DoorRepository repo;
  SetDoorThresholdUsecase(this.repo);

  Future<Result<void>> call(String ip, int threshold) =>
      repo.setThreshold(ip, threshold);
}
