import 'package:esp32_app/features/luces/domain/entities/luces_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/http_client.dart';
import '../../data/datasources/luces_remote_datasource.dart';
import '../../data/repositories/luces_repository_impl.dart';
import '../../domain/usecases/set_relay_usecase.dart';
import '../controllers/luces_controller.dart';

// http client
final httpClientProvider = Provider((ref) => HttpClient(http.Client()));

// datasource
final lucesRemoteDatasourceProvider = Provider(
  (ref) => LucesRemoteDatasource(ref.read(httpClientProvider)),
);

// repository
final lucesRepositoryProvider = Provider(
  (ref) => LucesRepositoryImpl(ref.read(lucesRemoteDatasourceProvider)),
);

// usecase
final setRelayUsecaseProvider = Provider(
  (ref) => SetRelayUsecase(ref.read(lucesRepositoryProvider)),
);

// controller
final lucesControllerProvider =
    StateNotifierProvider<LucesController, LucesState>(
      (ref) => LucesController(ref.read(setRelayUsecaseProvider)),
    );
