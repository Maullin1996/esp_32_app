import '../../../../core/utils/result.dart';
import '../repositories/temp_repository.dart';

class SetManualUsecase {
  final TempRepository repo;
  SetManualUsecase(this.repo);

  Future<Result<void>> call({required String ip, required double target}) =>
      repo.setManual(ip: ip, target: target);
}
