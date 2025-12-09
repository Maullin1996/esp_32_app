import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VentNamesStorage {
  Future<List<String>> loadNames(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("vent_names_$ip");

    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  Future<void> saveNames(String ip, List<String> names) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("vent_names_$ip", jsonEncode(names));
  }
}
