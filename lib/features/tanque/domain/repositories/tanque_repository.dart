import '../../../../core/utils/result.dart';
import '../entities/tanque_state.dart';

abstract class TanqueRepository {
  Future<Result<TanqueState>> getStatus(String ip);

  Future<Result<void>> setManual({required String ip, required double target});

  Future<Result<void>> setRange({
    required String ip,
    required double min,
    required double max,
  });

  Future<Result<void>> stop(String ip);
}
