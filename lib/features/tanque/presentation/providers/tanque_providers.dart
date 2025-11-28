import 'package:esp32_app/core/providers/http_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/tanque_remote_datasource.dart';
import '../../data/repositories/tanque_repository_impl.dart';
import '../../domain/usecases/get_tanque_status_usecase.dart';
import '../../domain/usecases/set_tanque_manual_usecase.dart';
import '../../domain/usecases/set_tanque_range_usecase.dart';
import '../../domain/usecases/stop_tanque_usecase.dart';
import '../controllers/tanque_controller.dart';
import '../../domain/entities/tanque_state.dart';

final tanqueDatasourceProvider = Provider(
  (ref) => TanqueRemoteDatasource(ref.read(httpClientProvider)),
);

final tanqueRepositoryProvider = Provider(
  (ref) => TanqueRepositoryImpl(ref.read(tanqueDatasourceProvider)),
);

final getTanqueStatusUsecaseProvider = Provider(
  (ref) => GetTanqueStatusUsecase(ref.read(tanqueRepositoryProvider)),
);

final setTanqueManualUsecaseProvider = Provider(
  (ref) => SetTanqueManualUsecase(ref.read(tanqueRepositoryProvider)),
);

final setTanqueRangeUsecaseProvider = Provider(
  (ref) => SetTanqueRangeUsecase(ref.read(tanqueRepositoryProvider)),
);

final stopTanqueUsecaseProvider = Provider(
  (ref) => StopTanqueUsecase(ref.read(tanqueRepositoryProvider)),
);

final tanqueControllerProvider =
    StateNotifierProvider<TanqueController, TanqueState>(
      (ref) => TanqueController(
        ref.read(getTanqueStatusUsecaseProvider),
        ref.read(setTanqueManualUsecaseProvider),
        ref.read(setTanqueRangeUsecaseProvider),
        ref.read(stopTanqueUsecaseProvider),
      ),
    );
