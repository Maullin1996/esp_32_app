import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../devices/presentation/providers/device_providers.dart';

class HumedadPage extends ConsumerStatefulWidget {
  const HumedadPage({super.key});

  @override
  ConsumerState<HumedadPage> createState() => _HumedadPageState();
}

class _HumedadPageState extends ConsumerState<HumedadPage> {
  int humedad = 0;
  int target = 40;

  Future<void> leerEstado() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/status");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      setState(() {
        humedad = jsonDecode(res.body)["humedad"];
      });
    }
  }

  Future<void> enviarTarget() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/set-humedad");

    await http.post(url, body: {"target": target.toString()});
  }

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(selectedDeviceProvider);
    if (device == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ Selecciona un ESP32 primero")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Humedad suelo (${device.name})")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Humedad: $humedad%", style: const TextStyle(fontSize: 22)),
          ElevatedButton(
            onPressed: leerEstado,
            child: const Text("Actualizar"),
          ),
          const Divider(),
          Text("Target humedad: $target%"),
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
