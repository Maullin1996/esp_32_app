// lib/features/mq2/presentation/providers/mq2_providers.dart

import 'package:esp32_app/core/providers/http_provider.dart';

import 'package:esp32_app/features/mq2/data/datasources/mq2_remote_datasource.dart';
import 'package:esp32_app/features/mq2/data/repositories/mq2_repository_impl.dart';
import 'package:esp32_app/features/mq2/domain/repositories/mq2_repository.dart';
import 'package:esp32_app/features/mq2/domain/usecases/get_mq2_status_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_auto_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_thresholds_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_alarm_manual_usecase.dart';
import 'package:esp32_app/features/mq2/domain/usecases/set_mq2_sensing_usecase.dart';
import 'package:esp32_app/features/mq2/domain/entities/mq2_state.dart';
import 'package:esp32_app/features/mq2/presentation/controllers/mq2_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DATASOURCE
final mq2DatasourceProvider = Provider<Mq2RemoteDatasource>(
  (ref) => Mq2RemoteDatasource(ref.read(httpClientProvider)),
);

// REPOSITORY
final mq2RepositoryProvider = Provider<Mq2Repository>(
  (ref) => Mq2RepositoryImpl(ref.read(mq2DatasourceProvider)),
);

// USECASES
final getMq2StatusUsecaseProvider = Provider(
  (ref) => GetMq2StatusUsecase(ref.read(mq2RepositoryProvider)),
);

final setMq2AutoUsecaseProvider = Provider(
  (ref) => SetMq2AutoUsecase(ref.read(mq2RepositoryProvider)),
);

final setMq2ThresholdsUsecaseProvider = Provider(
  (ref) => SetMq2ThresholdsUsecase(ref.read(mq2RepositoryProvider)),
);

final setMq2AlarmManualUsecaseProvider = Provider(
  (ref) => SetMq2AlarmManualUsecase(ref.read(mq2RepositoryProvider)),
);

final setMq2SensingUsecaseProvider = Provider(
  (ref) => SetMq2SensingUsecase(ref.read(mq2RepositoryProvider)),
);

// CONTROLLER
final mq2ControllerProvider =
    StateNotifierProvider.autoDispose<Mq2Controller, Mq2State>((ref) {
      final c = Mq2Controller(
        ref.read(getMq2StatusUsecaseProvider),
        ref.read(setMq2AutoUsecaseProvider),
        ref.read(setMq2ThresholdsUsecaseProvider),
        ref.read(setMq2AlarmManualUsecaseProvider),
        ref.read(setMq2SensingUsecaseProvider),
      );

      ref.onDispose(c.dispose);
      return c;
    });
