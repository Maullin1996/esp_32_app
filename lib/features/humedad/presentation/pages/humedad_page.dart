import 'dart:convert';
import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/humedad/presentation/controllers/humedad_controller.dart';
import 'package:esp32_app/features/humedad/presentation/providers/humedad_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HumedadPage extends ConsumerStatefulWidget {
  const HumedadPage({super.key});

  @override
  ConsumerState<HumedadPage> createState() => _HumedadPageState();
}

class _HumedadPageState extends ConsumerState<HumedadPage> {
  int humedad = 0;
  int target = 40;
  late HumedadController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(humedadControllerProvider.notifier);

    Future.microtask(() {
      final ip = ref.read(assignedDevicesProvider)["humedad"];
      if (ip != null) {
        _controller.setIp(ip);
      }
    });
  }

  @override
  void dispose() {
    _controller.stopPolling();
    super.dispose();
  }

  Future<void> leerEstado() async {
    final ip = ref.read(assignedDevicesProvider)["humedad"];
    if (ip == null) return;

    final res = await http.get(Uri.http(ip, "/status"));
    if (res.statusCode == 200) {
      humedad = jsonDecode(res.body)["humidity"];
      setState(() {});
    }
  }

  Future<void> enviarTarget() async {
    final ip = ref.read(assignedDevicesProvider)["humedad"];
    if (ip == null) return;

    await http.post(
      Uri.http(ip, "/set_manual"),
      body: {"target": target.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ip = ref.watch(assignedDevicesProvider)["humedad"];

    if (ip == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Humedad")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Humedad (ESP: $ip)")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Humedad: $humedad%", style: const TextStyle(fontSize: 22)),
          ElevatedButton(
            onPressed: leerEstado,
            child: const Text("Actualizar"),
          ),
          const Divider(),
          Slider(
            value: target.toDouble(),
            min: 0,
            max: 100,
            onChanged: (v) => setState(() => target = v.toInt()),
          ),
          ElevatedButton(onPressed: enviarTarget, child: const Text("Guardar")),
        ],
      ),
    );
  }
}
