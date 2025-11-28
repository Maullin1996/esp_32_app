import 'package:esp32_app/core/storage/assigned_devices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignedDevicesProvider =
    StateNotifierProvider<AssignedDevicesController, Map<String, String>>(
      (ref) => AssignedDevicesController(AssignedDevices()),
    );

class AssignedDevicesController extends StateNotifier<Map<String, String>> {
  final AssignedDevices storage;

  AssignedDevicesController(this.storage) : super({}) {
    _load();
  }

  Future<void> _load() async {
    state = await storage.load();
  }

  void assign(String module, String ip) {
    final newState = {...state, module: ip};
    state = newState;
    storage.save(newState);
  }

  String? getIp(String module) => state[module];
}
