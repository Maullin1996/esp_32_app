import 'package:esp32_app/features/temperatura/presentation/controllers/temp_controller.dart';
import 'package:esp32_app/features/temperatura/presentation/providers/temp_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../devices/presentation/providers/device_providers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TemperaturaPage extends ConsumerStatefulWidget {
  const TemperaturaPage({super.key});

  @override
  ConsumerState<TemperaturaPage> createState() => _TemperaturaPageState();
}

class _TemperaturaPageState extends ConsumerState<TemperaturaPage> {
  late TempController _tempController;
  double? temperaturaActual;
  double target = 30.0;
  bool modoRango = false;
  double rangoMin = 28.0;
  double rangoMax = 32.0;

  Future<void> leerEstado() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/status");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        temperaturaActual = data["temp"];
      });
    }
  }

  Future<void> enviarTarget() async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/set-target");

    final res = await http.post(
      url,
      body: {
        "modo": modoRango ? "rango" : "simple",
        "min": rangoMin.toString(),
        "max": rangoMax.toString(),
        "target": target.toString(),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Guardamos el notifier una sola vez
    _tempController = ref.read(tempControllerProvider.notifier);
    Future.microtask(() {
      final device = ref.read(selectedDeviceProvider);
      if (device != null) {
        _tempController.setIp(device.ip);
      }
    });
  }

  @override
  void dispose() {
    // Aquí ya NO usamos ref, sino la instancia guardada
    _tempController.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tempControllerProvider);
    final device = ref.watch(selectedDeviceProvider);
    if (device == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ Selecciona un ESP32 primero")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Temperatura (${device.name})")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            temperaturaActual != null
                ? "Temperatura actual: $temperaturaActual°C"
                : "Sin datos",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: leerEstado,
            child: const Text("Actualizar temperatura"),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Modo rango"),
            value: modoRango,
            onChanged: (v) => setState(() => modoRango = v),
          ),
          if (!modoRango)
            Slider(
              value: target,
              min: 10,
              max: 80,
              onChanged: (v) => setState(() => target = v),
            )
          else
            Column(
              children: [
                Slider(
                  value: rangoMin,
                  min: 10,
                  max: 80,
                  onChanged: (v) => setState(() => rangoMin = v),
                ),
                Slider(
                  value: rangoMax,
                  min: 10,
                  max: 80,
                  onChanged: (v) => setState(() => rangoMax = v),
                ),
              ],
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
