import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:esp32_app/core/network/http_client.dart';
import 'package:esp32_app/features/temperatura/data/datasources/temp_remote_datasource.dart';
import 'package:esp32_app/features/temperatura/data/repositories/temp_repository_impl.dart';
import 'package:esp32_app/features/temperatura/domain/entities/temp_state.dart';
import 'package:esp32_app/features/temperatura/domain/repositories/temp_repository.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/force_off_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/get_status_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/set_range_usecase.dart';
import 'package:esp32_app/features/temperatura/domain/usecases/toggle_auto_usecase.dart';
import 'package:esp32_app/features/temperatura/presentation/controllers/temp_controller.dart';

// HttpClient global (si ya lo tienes, usa ese)
final httpClientProvider = Provider((ref) => HttpClient(http.Client()));

final tempDatasourceProvider = Provider(
  (ref) => TempRemoteDatasource(ref.read(httpClientProvider)),
);

final tempRepositoryProvider = Provider<TempRepository>(
  (ref) => TempRepositoryImpl(ref.read(tempDatasourceProvider)),
);

final getStatusUsecaseProvider = Provider(
  (ref) => GetStatusUsecase(ref.read(tempRepositoryProvider)),
);

final setRangeUsecaseProvider = Provider(
  (ref) => SetRangeUsecase(ref.read(tempRepositoryProvider)),
);

final toggleAutoUsecaseProvider = Provider(
  (ref) => ToggleAutoUsecase(ref.read(tempRepositoryProvider)),
);

final forceOffUsecaseProvider = Provider(
  (ref) => ForceOffUsecase(ref.read(tempRepositoryProvider)),
);

final tempControllerProvider =
    StateNotifierProvider.autoDispose<TempController, TempState>(
      (ref) => TempController(
        ref.read(getStatusUsecaseProvider),
        ref.read(setRangeUsecaseProvider),
        ref.read(toggleAutoUsecaseProvider),
        ref.read(forceOffUsecaseProvider),
      ),
    );
