import '../../../../core/utils/result.dart';
import '../repositories/luces_repository.dart';

class SetRelayUsecase {
  final LucesRepository repo;
  SetRelayUsecase(this.repo);

  Future<Result<void>> call({
    required String ip,
    required int id,
    required bool state,
  }) => repo.setRelay(ip: ip, id: id, state: state);
}
