import '../../../../core/utils/result.dart';
import '../entities/vent_state.dart';

abstract class VentRepository {
  Future<Result<VentState>> getStatus(String ip);
  Future<Result<void>> setManual(String ip, double target);
  Future<Result<void>> setRange(String ip, double min, double max);
  Future<Result<void>> stop(String ip);
}
