import 'dart:convert';
import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/tanque/presentation/controllers/tanque_controller.dart';
import 'package:esp32_app/features/tanque/presentation/providers/tanque_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class TanquePage extends ConsumerStatefulWidget {
  const TanquePage({super.key});

  @override
  ConsumerState<TanquePage> createState() => _TanquePageState();
}

class _TanquePageState extends ConsumerState<TanquePage> {
  double distancia = 0;
  double nivel = 0;
  int target = 20;

  late TanqueController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(tanqueControllerProvider.notifier);

    Future.microtask(() {
      final ip = ref.read(assignedDevicesProvider)["tanque"];
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
    final ip = ref.read(assignedDevicesProvider)["tanque"];
    if (ip == null) return;

    final res = await http.get(Uri.http(ip, "/status"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        distancia = data["distance_cm"];
        nivel = data["level"];
      });
    }
  }

  Future<void> enviarTarget() async {
    final ip = ref.read(assignedDevicesProvider)["tanque"];
    if (ip == null) return;

    await http.post(
      Uri.http(ip, "/set_manual"),
      body: {"target": target.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ip = ref.watch(assignedDevicesProvider)["tanque"];

    if (ip == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Tanque")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Tanque (ESP: $ip)")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Distancia: ${distancia}cm",
            style: const TextStyle(fontSize: 22),
          ),
          Text("Nivel: $nivel%", style: const TextStyle(fontSize: 22)),
          ElevatedButton(
            onPressed: leerEstado,
            child: const Text("Actualizar"),
          ),
          const Divider(),
          Slider(
            min: 0,
            max: 100,
            value: target.toDouble(),
            onChanged: (v) => setState(() => target = v.toInt()),
          ),
          ElevatedButton(onPressed: enviarTarget, child: const Text("Guardar")),
        ],
      ),
    );
  }
}
