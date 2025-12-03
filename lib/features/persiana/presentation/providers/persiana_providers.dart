import 'package:esp32_app/features/persiana/data/datasources/persiana_remote_datasource.dart';
import 'package:esp32_app/features/persiana/data/repositories/persiana_repository_impl.dart';
import 'package:esp32_app/features/persiana/domain/entities/persiana_state.dart';
import 'package:esp32_app/features/persiana/domain/repositories/persiana_repository.dart';
import 'package:esp32_app/features/persiana/domain/usecases/get_persiana_status_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/send_manual_action_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_auto_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_pwm_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_range_usecase.dart';
import 'package:esp32_app/features/persiana/domain/usecases/set_persiana_timing_usecase.dart';
import 'package:esp32_app/features/persiana/presentation/controllers/persiana_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:esp32_app/core/providers/http_provider.dart';

final persianaDatasourceProvider = Provider(
  (ref) => PersianaRemoteDatasource(ref.read(httpClientProvider)),
);

final persianaRepositoryProvider = Provider<PersianaRepository>(
  (ref) => PersianaRepositoryImpl(ref.read(persianaDatasourceProvider)),
);

final getPersianaStatusUsecaseProvider = Provider(
  (ref) => GetPersianaStatusUsecase(ref.read(persianaRepositoryProvider)),
);

final setPersianaRangeUsecaseProvider = Provider(
  (ref) => SetPersianaRangeUsecase(ref.read(persianaRepositoryProvider)),
);

final setPersianaPwmUsecaseProvider = Provider(
  (ref) => SetPersianaPwmUsecase(ref.read(persianaRepositoryProvider)),
);

final setPersianaTimingUsecaseProvider = Provider(
  (ref) => SetPersianaTimingUsecase(ref.read(persianaRepositoryProvider)),
);

final setPersianaAutoUsecaseProvider = Provider(
  (ref) => SetPersianaAutoUsecase(ref.read(persianaRepositoryProvider)),
);

final sendManualActionUsecaseProvider = Provider(
  (ref) => SendManualActionUsecase(ref.read(persianaRepositoryProvider)),
);

final persianaControllerProvider =
    StateNotifierProvider.autoDispose<PersianaController, PersianaState>(
      (ref) => PersianaController(
        ref.read(getPersianaStatusUsecaseProvider),
        ref.read(setPersianaRangeUsecaseProvider),
        ref.read(setPersianaPwmUsecaseProvider),
        ref.read(setPersianaTimingUsecaseProvider),
        ref.read(setPersianaAutoUsecaseProvider),
        ref.read(sendManualActionUsecaseProvider),
      ),
    );
