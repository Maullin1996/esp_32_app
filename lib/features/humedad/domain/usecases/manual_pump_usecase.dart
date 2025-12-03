import '../../../../core/utils/result.dart';
import '../repositories/humedad_repository.dart';

class ManualPumpUsecase {
  final HumedadRepository repo;
  ManualPumpUsecase(this.repo);

  Future<Result<void>> call({required String ip, required bool state}) =>
      repo.manualPump(ip, state);
}
