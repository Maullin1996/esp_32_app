import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/http_client.dart';
import '../../data/datasources/humedad_remote_datasource.dart';
import '../../data/repositories/humedad_repository_impl.dart';
import '../../domain/usecases/get_humedad_status_usecase.dart';
import '../../domain/usecases/set_humedad_manual_usecase.dart';
import '../../domain/usecases/set_humedad_range_usecase.dart';
import '../../domain/usecases/stop_humedad_usecase.dart';
import '../controllers/humedad_controller.dart';
import '../../domain/entities/humedad_state.dart';

final humedadHttpClientProvider = Provider((ref) => HttpClient(http.Client()));

final humedadDatasourceProvider = Provider(
  (ref) => HumedadRemoteDatasource(ref.read(humedadHttpClientProvider)),
);

final humedadRepositoryProvider = Provider(
  (ref) => HumedadRepositoryImpl(ref.read(humedadDatasourceProvider)),
);

final getHumedadStatusUsecaseProvider = Provider(
  (ref) => GetHumedadStatusUsecase(ref.read(humedadRepositoryProvider)),
);

final setHumedadManualUsecaseProvider = Provider(
  (ref) => SetHumedadManualUsecase(ref.read(humedadRepositoryProvider)),
);

final setHumedadRangeUsecaseProvider = Provider(
  (ref) => SetHumedadRangeUsecase(ref.read(humedadRepositoryProvider)),
);

final stopHumedadUsecaseProvider = Provider(
  (ref) => StopHumedadUsecase(ref.read(humedadRepositoryProvider)),
);

final humedadControllerProvider =
    StateNotifierProvider<HumedadController, HumedadState>(
      (ref) => HumedadController(
        ref.read(getHumedadStatusUsecaseProvider),
        ref.read(setHumedadManualUsecaseProvider),
        ref.read(setHumedadRangeUsecaseProvider),
        ref.read(stopHumedadUsecaseProvider),
      ),
    );
