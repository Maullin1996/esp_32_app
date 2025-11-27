import '../../../../core/utils/result.dart';
import '../repositories/luces_repository.dart';

class SetRelaysUsecase {
  final LucesRepository repo;
  SetRelaysUsecase(this.repo);

  Future<Result<void>> call({required String ip, required List<bool> states}) =>
      repo.setRelays(ip: ip, states: states);
}
