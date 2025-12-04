import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/puerta/domain/entities/door_state.dart';

abstract class DoorRepository {
  Future<Result<DoorState>> getStatus(String ip);

  Future<Result<void>> setThreshold(String ip, int threshold);

  Future<Result<void>> setAuto(String ip, bool enabled);

  Future<Result<void>> manualOpen(String ip);
  Future<Result<void>> manualClose(String ip);
  Future<Result<void>> manualStop(String ip);
}
