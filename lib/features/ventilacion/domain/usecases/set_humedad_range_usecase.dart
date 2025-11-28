import '../../../../core/utils/result.dart';
import '../repositories/vent_repository.dart';

class SetVentManualUsecase {
  final VentRepository repo;
  SetVentManualUsecase(this.repo);

  Future<Result<void>> call(String ip, double target) =>
      repo.setManual(ip, target);
}
