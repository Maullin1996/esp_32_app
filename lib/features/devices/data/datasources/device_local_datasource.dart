import '../../../../core/storage/devices_storage.dart';
import '../../domain/entities/device_entity.dart';

class DeviceLocalDatasource {
  final DevicesStorage storage;
  DeviceLocalDatasource(this.storage);

  Future<List<DeviceEntity>> getDevices() => storage.loadDevices();

  Future<void> saveDevices(List<DeviceEntity> devices) =>
      storage.saveDevices(devices);
}
