import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/humedad/presentation/providers/humedad_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HumedadPage extends ConsumerStatefulWidget {
  const HumedadPage({super.key});

  @override
  ConsumerState<HumedadPage> createState() => _HumedadPageState();
}

class _HumedadPageState extends ConsumerState<HumedadPage> {
  bool _initialized = false;
  double _newMin = 30;
  double _newMax = 60;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;

        final ip = ref.read(assignedDevicesProvider)["humedad"];
        if (ip != null) {
          ref.read(humedadControllerProvider.notifier).setIp(ip);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hum = ref.watch(humedadControllerProvider);
    final controller = ref.read(humedadControllerProvider.notifier);

    if (hum.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Humedad Suelo")),
      );
    }

    // Sincronizar sliders la primera vez
    _newMin = (_newMin == 30) ? hum.rangeMin : _newMin;
    _newMax = (_newMax == 60) ? hum.rangeMax : _newMax;

    return Scaffold(
      appBar: AppBar(title: Text("Humedad Suelo (ESP: ${hum.espIp})")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "💧 Humedad: ${hum.humidity.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              "Rango actual: "
              "${hum.rangeMin.toStringAsFixed(1)}% - "
              "${hum.rangeMax.toStringAsFixed(1)}%",
            ),
            Text("Sensado: ${hum.autoEnabled ? "Activado" : "Desactivado"}"),
            Text("Bomba: ${hum.pumpOn ? "🚿 Encendida" : "⛔ Apagada"}"),
            if (hum.error != null)
              Text(
                "Error: ${hum.error}",
                style: const TextStyle(color: Colors.red),
              ),

            const Divider(height: 32),

            const Text("Configurar rango de humedad (%)"),
            const SizedBox(height: 8),

            Text("Mínimo: ${_newMin.toStringAsFixed(1)}%"),
            Slider(
              value: _newMin,
              min: 0,
              max: _newMax - 1,
              onChanged: (v) {
                setState(() {
                  _newMin = v;
                  if (_newMax <= _newMin) {
                    _newMax = _newMin + 1;
                  }
                });
              },
            ),

            Text("Máximo: ${_newMax.toStringAsFixed(1)}%"),
            Slider(
              value: _newMax,
              min: _newMin + 1,
              max: 100,
              onChanged: (v) {
                setState(() {
                  _newMax = v;
                  if (_newMax <= _newMin) {
                    _newMin = _newMax - 1;
                  }
                });
              },
            ),

            Center(
              child: ElevatedButton(
                onPressed: hum.isLoading
                    ? null
                    : () => controller.applyRange(_newMin, _newMax),
                child: const Text("Guardar rango"),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    hum.autoEnabled ? Colors.red : Colors.green,
                  ),
                ),
                onPressed: controller.toggleAuto,
                icon: Icon(
                  hum.autoEnabled ? Icons.pause_circle : Icons.play_circle,
                ),
                label: Text(
                  hum.autoEnabled ? "Desactivar sensado" : "Activar sensado",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => controller.setPump(true),
                  icon: const Icon(Icons.water),
                  label: const Text("Encender bomba"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => controller.setPump(false),
                  icon: const Icon(Icons.stop),
                  label: const Text("Apagar bomba"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
