import '../../../../core/utils/result.dart';
import '../entities/temp_state.dart';

abstract class TempRepository {
  Future<Result<TempState>> getStatus(String ip);

  Future<Result<void>> setRange({
    required String ip,
    required double min,
    required double max,
  });

  Future<Result<void>> toggleAuto({required String ip, required bool enabled});

  Future<Result<void>> forceOff(String ip);
}
