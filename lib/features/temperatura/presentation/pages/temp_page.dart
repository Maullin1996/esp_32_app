import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/temperatura/presentation/controllers/temp_controller.dart';
import 'package:esp32_app/features/temperatura/presentation/providers/temp_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TemperaturaPage extends ConsumerStatefulWidget {
  const TemperaturaPage({super.key});

  @override
  ConsumerState<TemperaturaPage> createState() => _TemperaturaPageState();
}

class _TemperaturaPageState extends ConsumerState<TemperaturaPage> {
  double? temperaturaActual;
  double target = 30.0;
  bool modoRango = false;
  double rangoMin = 28.0;
  double rangoMax = 32.0;

  late TempController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(tempControllerProvider.notifier);

    Future.microtask(() {
      final ip = ref.read(assignedDevicesProvider)["temperatura"];
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
    final ip = ref.read(assignedDevicesProvider)["temperatura"];
    if (ip == null) return;

    final url = Uri.http(ip, "/status");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        temperaturaActual = data["temperature"];
      });
    }
  }

  Future<void> enviarTarget() async {
    final ip = ref.read(assignedDevicesProvider)["temperatura"];
    if (ip == null) return;

    final url = Uri.http(ip, "/set_manual");
    await http.post(url, body: {"target": target.toString()});
  }

  @override
  Widget build(BuildContext context) {
    final ip = ref.watch(assignedDevicesProvider)["temperatura"];

    if (ip == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Temperatura")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Temperatura (ESP: $ip)")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            temperaturaActual != null
                ? "Temperatura actual: $temperaturaActual°C"
                : "Sin datos",
            style: const TextStyle(fontSize: 22),
          ),
          ElevatedButton(
            onPressed: leerEstado,
            child: const Text("Actualizar temperatura"),
          ),
          const Divider(),
          Slider(
            value: target,
            min: 10,
            max: 80,
            onChanged: (v) => setState(() => target = v),
          ),
          ElevatedButton(
            onPressed: enviarTarget,
            child: const Text("Enviar configuración"),
          ),
        ],
      ),
    );
  }
}
