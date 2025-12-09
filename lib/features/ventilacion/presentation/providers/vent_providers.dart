import 'package:esp32_app/core/providers/http_provider.dart';
import 'package:esp32_app/features/ventilacion/data/datasources/vent_remote_datasource.dart';
import 'package:esp32_app/features/ventilacion/data/repositories/vent_repository_impl.dart';
import 'package:esp32_app/features/ventilacion/data/storage/vent_names_storage.dart';
import 'package:esp32_app/features/ventilacion/domain/entities/vent_state.dart';
import 'package:esp32_app/features/ventilacion/domain/repositories/vent_repository.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/get_vent_status_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_vent_fan_manual_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_vent_range_usecase.dart';
import 'package:esp32_app/features/ventilacion/domain/usecases/set_vent_auto_use_case.dart';
import 'package:esp32_app/features/ventilacion/presentation/controllers/vent_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ventDatasourceProvider = Provider(
  (ref) => VentRemoteDatasource(ref.read(httpClientProvider)),
);

final ventRepositoryProvider = Provider<VentRepository>(
  (ref) => VentRepositoryImpl(ref.read(ventDatasourceProvider)),
);

final getVentStatusUsecaseProvider = Provider(
  (ref) => GetVentStatusUsecase(ref.read(ventRepositoryProvider)),
);

final setVentRangeUsecaseProvider = Provider(
  (ref) => SetVentRangeUsecase(ref.read(ventRepositoryProvider)),
);

final setVentAutoUsecaseProvider = Provider(
  (ref) => SetVentAutoUsecase(ref.read(ventRepositoryProvider)),
);

final setVentFanManualUsecaseProvider = Provider(
  (ref) => SetVentFanManualUsecase(ref.read(ventRepositoryProvider)),
);

final ventNamesStorageProvider = Provider((ref) => VentNamesStorage());

final ventControllerProvider =
    StateNotifierProvider.autoDispose<VentController, VentState>(
      (ref) => VentController(
        ref.read(getVentStatusUsecaseProvider),
        ref.read(setVentRangeUsecaseProvider),
        ref.read(setVentAutoUsecaseProvider),
        ref.read(setVentFanManualUsecaseProvider),
        ref.read(ventNamesStorageProvider),
      ),
    );
