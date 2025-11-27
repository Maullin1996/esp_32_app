import '../../../../core/utils/result.dart';
import '../../domain/repositories/luces_repository.dart';
import '../datasources/luces_remote_datasource.dart';

class LucesRepositoryImpl implements LucesRepository {
  final LucesRemoteDatasource remote;
  LucesRepositoryImpl(this.remote);

  @override
  Future<Result<void>> setRelay({
    required String ip,
    required int id,
    required bool state,
  }) async {
    try {
      final res = await remote
          .setRelay(ip: ip, id: id, state: state)
          .timeout(const Duration(seconds: 2));

      if (res.statusCode == 200) return const Success(null);
      return Failure('HTTP ${res.statusCode}');
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> setRelays({
    required String ip,
    required List<bool> states,
  }) async {
    try {
      final res = await remote
          .setRelays(ip: ip, states: states)
          .timeout(const Duration(seconds: 2));

      if (res.statusCode == 200) return const Success(null);
      return Failure('HTTP ${res.statusCode}');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
