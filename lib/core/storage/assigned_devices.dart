import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AssignedDevices {
  static const key = "assigned_devices";

  Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw));
  }

  Future<void> save(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }
}
