import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceController extends StateNotifier<List<DeviceEntity>> {
  final DeviceRepository repo;

  DeviceController(this.repo) : super([]) {
    load();
  }

  Future<void> load() async {
    final devices = await repo.getDevices();
    state = devices;
  }

  Future<void> addDevice(DeviceEntity device) async {
    final newList = [...state, device];
    state = newList;
    await repo.saveDevices(newList);
  }

  Future<void> removeDevice(int index) async {
    final newList = [...state]..removeAt(index);
    state = newList;
    await repo.saveDevices(newList);
  }
}
