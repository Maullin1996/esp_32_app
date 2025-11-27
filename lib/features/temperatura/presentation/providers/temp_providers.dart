import 'package:esp32_app/features/temperatura/domain/entities/temp_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/http_client.dart';
import '../../data/datasources/temp_remote_datasource.dart';
import '../../data/repositories/temp_repository_impl.dart';
import '../../domain/usecases/get_status_usecase.dart';
import '../../domain/usecases/set_manual_usecase.dart';
import '../../domain/usecases/set_range_usecase.dart';
import '../../domain/usecases/stop_usecase.dart';
import '../controllers/temp_controller.dart';

final httpClientProvider = Provider((ref) => HttpClient(http.Client()));

final tempDatasourceProvider = Provider(
  (ref) => TempRemoteDatasource(ref.read(httpClientProvider)),
);

final tempRepositoryProvider = Provider(
  (ref) => TempRepositoryImpl(ref.read(tempDatasourceProvider)),
);

final getStatusUsecaseProvider = Provider(
  (ref) => GetStatusUsecase(ref.read(tempRepositoryProvider)),
);

final setManualUsecaseProvider = Provider(
  (ref) => SetManualUsecase(ref.read(tempRepositoryProvider)),
);

final setRangeUsecaseProvider = Provider(
  (ref) => SetRangeUsecase(ref.read(tempRepositoryProvider)),
);

final stopUsecaseProvider = Provider(
  (ref) => StopUsecase(ref.read(tempRepositoryProvider)),
);

final tempControllerProvider = StateNotifierProvider<TempController, TempState>(
  (ref) => TempController(
    ref.read(getStatusUsecaseProvider),
    ref.read(setManualUsecaseProvider),
    ref.read(setRangeUsecaseProvider),
    ref.read(stopUsecaseProvider),
  ),
);
