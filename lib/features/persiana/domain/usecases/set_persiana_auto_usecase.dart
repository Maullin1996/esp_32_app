import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class SetPersianaAutoUsecase {
  final PersianaRepository repo;
  SetPersianaAutoUsecase(this.repo);

  Future<Result<void>> call(String ip, bool enabled) =>
      repo.setAuto(ip, enabled);
}
