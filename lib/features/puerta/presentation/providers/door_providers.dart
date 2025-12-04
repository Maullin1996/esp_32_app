import 'package:esp32_app/core/providers/http_provider.dart';
import 'package:esp32_app/features/puerta/data/datasources/door_remote_datasource.dart';
import 'package:esp32_app/features/puerta/data/repositories/door_repository_impl.dart';
import 'package:esp32_app/features/puerta/domain/entities/door_state.dart';
import 'package:esp32_app/features/puerta/domain/repositories/door_repository.dart';
import 'package:esp32_app/features/puerta/domain/usecases/door_manual_action_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/get_door_status_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/set_door_auto_usecase.dart';
import 'package:esp32_app/features/puerta/domain/usecases/set_door_threshold_usecase.dart';
import 'package:esp32_app/features/puerta/presentation/controller/door_controller.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final doorDatasourceProvider = Provider(
  (ref) => DoorRemoteDatasource(ref.read(httpClientProvider)),
);

final doorRepositoryProvider = Provider<DoorRepository>(
  (ref) => DoorRepositoryImpl(ref.read(doorDatasourceProvider)),
);

final getDoorStatusUsecaseProvider = Provider(
  (ref) => GetDoorStatusUsecase(ref.read(doorRepositoryProvider)),
);

final setDoorThresholdUsecaseProvider = Provider(
  (ref) => SetDoorThresholdUsecase(ref.read(doorRepositoryProvider)),
);

final setDoorAutoUsecaseProvider = Provider(
  (ref) => SetDoorAutoUsecase(ref.read(doorRepositoryProvider)),
);

final doorManualActionUsecaseProvider = Provider(
  (ref) => DoorManualActionUsecase(ref.read(doorRepositoryProvider)),
);

final doorControllerProvider =
    StateNotifierProvider.autoDispose<DoorController, DoorState>(
      (ref) => DoorController(
        ref.read(getDoorStatusUsecaseProvider),
        ref.read(setDoorThresholdUsecaseProvider),
        ref.read(setDoorAutoUsecaseProvider),
        ref.read(doorManualActionUsecaseProvider),
      ),
    );
