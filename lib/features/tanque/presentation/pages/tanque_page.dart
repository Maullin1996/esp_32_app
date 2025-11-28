import 'dart:convert';
import 'package:esp32_app/features/tanque/presentation/controllers/tanque_controller.dart';
import 'package:esp32_app/features/tanque/presentation/providers/tanque_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../devices/presentation/providers/device_providers.dart';

class TanquePage extends ConsumerStatefulWidget {
  const TanquePage({super.key});

  @override
  ConsumerState<TanquePage> createState() => _TanquePageState();
}

class _TanquePageState extends ConsumerState<TanquePage> {
  late TanqueController _tanqueController;
  double distancia = 0;
  double nivel = 0;
  int target = 20;

  Future<void> leerEstado() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/status");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        distancia = data["distancia"];
        nivel = data["nivel"];
      });
    }
  }

  Future<void> enviarTarget() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/set-nivel");
    await http.post(url, body: {"target": target.toString()});
  }

  @override
  void initState() {
    super.initState();
    _tanqueController = ref.read(tanqueControllerProvider.notifier);
    Future.microtask(() {
      final device = ref.read(selectedDeviceProvider);
      if (device != null) {
        _tanqueController.setIp(device.ip);
      }
    });
  }

  @override
  void dispose() {
    _tanqueController.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tanqueControllerProvider);
    final device = ref.watch(selectedDeviceProvider);
    if (device == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ Selecciona un ESP32 primero")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Tanque (${device.name})")),
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
          Text("Target llenado: $target%"),
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
