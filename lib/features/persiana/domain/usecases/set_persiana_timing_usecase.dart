import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class SetPersianaTimingUsecase {
  final PersianaRepository repo;
  SetPersianaTimingUsecase(this.repo);

  Future<Result<void>> call(String ip, int timeOpenMs, int timeCloseMs) =>
      repo.setTiming(ip, timeOpenMs, timeCloseMs);
}
