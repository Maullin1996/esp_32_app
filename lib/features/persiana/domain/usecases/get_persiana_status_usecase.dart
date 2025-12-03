import 'package:esp32_app/core/utils/result.dart';
import 'package:esp32_app/features/persiana/domain/entities/persiana_state.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';

class GetPersianaStatusUsecase {
  final PersianaRepository repo;
  GetPersianaStatusUsecase(this.repo);

  Future<Result<PersianaState>> call(String ip) => repo.getStatus(ip);
}
