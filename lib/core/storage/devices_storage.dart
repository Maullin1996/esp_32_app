import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/devices/domain/entities/device_entity.dart';

class DevicesStorage {
  static const key = "saved_devices";

  Future<List<DeviceEntity>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return [];

    final List list = jsonDecode(jsonString);

    return list.map((e) => DeviceEntity.fromJson(e)).toList();
  }

  Future<void> saveDevices(List<DeviceEntity> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(devices.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonString);
  }
}
