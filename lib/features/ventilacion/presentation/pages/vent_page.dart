import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/ventilacion/presentation/controllers/vent_controller.dart';
import 'package:esp32_app/features/ventilacion/presentation/providers/vent_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VentilacionPage extends ConsumerStatefulWidget {
  const VentilacionPage({super.key});

  @override
  ConsumerState<VentilacionPage> createState() => _VentilacionPageState();
}

class _VentilacionPageState extends ConsumerState<VentilacionPage> {
  late VentController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ref.read(ventControllerProvider.notifier);

    Future.microtask(() {
      final ip = ref.read(assignedDevicesProvider)["ventilacion"];
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ventControllerProvider);
    final ip = ref.watch(assignedDevicesProvider)["ventilacion"];

    if (ip == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Ventilación")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Ventilación (ESP: $ip)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Temperatura: ${state.temperature} °C",
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "Ventilador: ${state.fanOn ? "ENCENDIDO" : "APAGADO"}",
              style: TextStyle(
                color: state.fanOn ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),

            const Divider(height: 40),

            const Text("Modo Manual", style: TextStyle(fontSize: 18)),
            Slider(
              min: 15,
              max: 40,
              value: state.manualTarget,
              onChanged: (v) => _controller.applyManual(v),
            ),

            const Divider(),

            const Text("Modo Rango", style: TextStyle(fontSize: 18)),
            Text("Mínimo: ${state.rangeMin}"),
            Slider(
              min: 15,
              max: 40,
              value: state.rangeMin,
              onChanged: (v) => _controller.applyRange(v, state.rangeMax),
            ),

            Text("Máximo: ${state.rangeMax}"),
            Slider(
              min: 15,
              max: 40,
              value: state.rangeMax,
              onChanged: (v) => _controller.applyRange(state.rangeMin, v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _controller.stop(),
              child: const Text("Detener"),
            ),
          ],
        ),
      ),
    );
  }
}
