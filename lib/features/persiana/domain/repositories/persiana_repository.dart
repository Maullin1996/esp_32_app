import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/entities/persiana_state.dart';

abstract class PersianaRepository {
  Future<Result<PersianaState>> getStatus(String ip);

  Future<Result<void>> setRange(String ip, double min, double max);

  Future<Result<void>> setPwm(String ip, int pwm);

  Future<Result<void>> setTiming(String ip, int timeOpenMs, int timeCloseMs);

  Future<Result<void>> setAuto(String ip, bool enabled);

  Future<Result<void>> manualStart(
    String ip,
    String direction,
  ); // "open"/"close"

  Future<Result<void>> manualStop(String ip);
}
