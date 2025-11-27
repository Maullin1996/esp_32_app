import '../../../../core/utils/result.dart';
import '../repositories/tanque_repository.dart';

class SetTanqueManualUsecase {
  final TanqueRepository repo;
  SetTanqueManualUsecase(this.repo);

  Future<Result<void>> call({required String ip, required double target}) =>
      repo.setManual(ip: ip, target: target);
}
