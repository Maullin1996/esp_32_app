import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class SetPersianaPwmUsecase {
  final PersianaRepository repo;
  SetPersianaPwmUsecase(this.repo);

  Future<Result<void>> call(String ip, int pwm) => repo.setPwm(ip, pwm);
}
