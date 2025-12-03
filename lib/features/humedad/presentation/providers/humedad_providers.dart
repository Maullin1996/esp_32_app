import 'package:esp32_app/core/providers/http_provider.dart';
import 'package:esp32_app/features/humedad/domain/repositories/humedad_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/humedad_remote_datasource.dart';
import '../../data/repositories/humedad_repository_impl.dart';
import '../../domain/usecases/get_humedad_status_usecase.dart';
import '../../domain/usecases/manual_pump_usecase.dart';
import '../../domain/usecases/set_humedad_range_usecase.dart';
import '../../domain/usecases/stop_humedad_usecase.dart';
import '../controllers/humedad_controller.dart';
import '../../domain/entities/humedad_state.dart';

final humedadDatasourceProvider = Provider(
  (ref) => HumedadRemoteDatasource(ref.read(httpClientProvider)),
);

final humedadRepositoryProvider = Provider<HumedadRepository>(
  (ref) => HumedadRepositoryImpl(ref.read(humedadDatasourceProvider)),
);

final getHumedadStatusUsecaseProvider = Provider(
  (ref) => GetHumedadStatusUsecase(ref.read(humedadRepositoryProvider)),
);

final setHumedadRangeUsecaseProvider = Provider(
  (ref) => SetHumedadRangeUsecase(ref.read(humedadRepositoryProvider)),
);

final stopHumedadUsecaseProvider = Provider(
  (ref) => StopHumedadUsecase(ref.read(humedadRepositoryProvider)),
);

final manualPumpUsecaseProvider = Provider(
  (ref) => ManualPumpUsecase(ref.read(humedadRepositoryProvider)),
);

final humedadControllerProvider =
    StateNotifierProvider.autoDispose<HumedadController, HumedadState>(
      (ref) => HumedadController(
        ref.read(getHumedadStatusUsecaseProvider),
        ref.read(setHumedadRangeUsecaseProvider),
        ref.read(stopHumedadUsecaseProvider),
        ref.read(manualPumpUsecaseProvider),
      ),
    );
