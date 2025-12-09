import '../../../../core/utils/result.dart';
import '../entities/vent_state.dart';

abstract class VentRepository {
  Future<Result<VentState>> getStatus(String ip);
  Future<Result<void>> setRange(String ip, double min, double max);
  Future<Result<void>> setAuto(String ip, bool enabled);
  Future<Result<void>> setFanManual(String ip, int id, bool on);
}
