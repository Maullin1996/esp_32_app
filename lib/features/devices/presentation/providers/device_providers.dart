import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/devices_storage.dart';
import '../../data/datasources/device_local_datasource.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/repositories/device_repository.dart';
import '../controllers/device_controller.dart';

final devicesStorageProvider = Provider((ref) => DevicesStorage());

final deviceDatasourceProvider = Provider(
  (ref) => DeviceLocalDatasource(ref.read(devicesStorageProvider)),
);

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepositoryImpl(ref.read(deviceDatasourceProvider)),
);

final devicesControllerProvider =
    StateNotifierProvider<DeviceController, List<DeviceEntity>>(
      (ref) => DeviceController(ref.read(deviceRepositoryProvider)),
    );

/// Dispositivo seleccionado globalmente
final selectedDeviceProvider = StateProvider<DeviceEntity?>((ref) => null);
