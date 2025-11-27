import '../../../../core/utils/result.dart';

abstract class LucesRepository {
  Future<Result<void>> setRelay({
    required String ip,
    required int id,
    required bool state,
  });

  Future<Result<void>> setRelays({
    required String ip,
    required List<bool> states,
  });
}
