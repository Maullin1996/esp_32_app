import '../../../../core/utils/result.dart';
import '../repositories/humedad_repository.dart';

class SetHumedadManualUsecase {
  final HumedadRepository repo;
  SetHumedadManualUsecase(this.repo);

  Future<Result<void>> call({required String ip, required double target}) =>
      repo.setManual(ip: ip, target: target);
}
