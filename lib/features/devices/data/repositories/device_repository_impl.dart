import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_datasource.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceLocalDatasource local;

  DeviceRepositoryImpl(this.local);

  @override
  Future<List<DeviceEntity>> getDevices() => local.getDevices();

  @override
  Future<void> saveDevices(List<DeviceEntity> devices) =>
      local.saveDevices(devices);
}
