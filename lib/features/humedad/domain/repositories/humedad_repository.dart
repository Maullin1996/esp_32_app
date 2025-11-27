import '../../../../core/utils/result.dart';
import '../entities/humedad_state.dart';

abstract class HumedadRepository {
  Future<Result<HumedadState>> getStatus(String ip);

  Future<Result<void>> setManual({required String ip, required double target});

  Future<Result<void>> setRange({
    required String ip,
    required double min,
    required double max,
  });

  Future<Result<void>> stop(String ip);
}
