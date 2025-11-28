import 'package:esp32_app/core/providers/http_provider.dart';
import 'package:esp32_app/features/ventilacion/data/datasources/vent_remote_datasource.dart';
import 'package:esp32_app/features/ventilacion/data/repositories/vent_repository_impl.dart';
import 'package:esp32_app/features/ventilacion/domain/entities/vent_state.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/get_vent_status_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_humedad_range_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_vent_range_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/stop_vent_usecase.dart';
import 'package:esp32_app/features/ventilacion/presentation/controllers/vent_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ventDatasourceProvider = Provider(
  (ref) => VentRemoteDatasource(ref.read(httpClientProvider)),
);

final ventRepositoryProvider = Provider(
  (ref) => VentRepositoryImpl(ref.read(ventDatasourceProvider)),
);

final getVentStatusUsecaseProvider = Provider(
  (ref) => GetVentStatusUsecase(ref.read(ventRepositoryProvider)),
);

final setVentManualUsecaseProvider = Provider(
  (ref) => SetVentManualUsecase(ref.read(ventRepositoryProvider)),
);

final setVentRangeUsecaseProvider = Provider(
  (ref) => SetVentRangeUsecase(ref.read(ventRepositoryProvider)),
);

final stopVentUsecaseProvider = Provider(
  (ref) => StopVentUsecase(ref.read(ventRepositoryProvider)),
);

final ventControllerProvider = StateNotifierProvider<VentController, VentState>(
  (ref) => VentController(
    ref.read(getVentStatusUsecaseProvider),
    ref.read(setVentManualUsecaseProvider),
    ref.read(setVentRangeUsecaseProvider),
    ref.read(stopVentUsecaseProvider),
  ),
);
