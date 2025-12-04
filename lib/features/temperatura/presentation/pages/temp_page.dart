import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/temperatura/presentation/providers/temp_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemperaturaPage extends ConsumerStatefulWidget {
  const TemperaturaPage({super.key});

  @override
  ConsumerState<TemperaturaPage> createState() => _TemperaturaPageState();
}

class _TemperaturaPageState extends ConsumerState<TemperaturaPage> {
  bool _initialized = false;
  double _newMin = 30;
  double _newMax = 35;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;

        final ip = ref.read(assignedDevicesProvider)["temperatura"];
        if (ip != null) {
          ref.read(tempControllerProvider.notifier).setIp(ip);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = ref.watch(tempControllerProvider);
    final controller = ref.read(tempControllerProvider.notifier);

    if (temp.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Temperatura")),
      );
    }

    // Sincroniza sliders con estado inicial la primera vez
    _newMin = _newMin == 30 ? temp.rangeMin : _newMin;
    _newMax = _newMax == 35 ? temp.rangeMax : _newMax;

    return Scaffold(
      appBar: AppBar(title: Text("Temperatura (ESP: ${temp.espIp})")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🌡 Temperatura: ${temp.temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              "Rango actual: ${temp.rangeMin.toStringAsFixed(1)}°C - "
              "${temp.rangeMax.toStringAsFixed(1)}°C",
            ),
            Text("Sensado: ${temp.autoEnabled ? "Activado" : "Desactivado"}"),
            Text("Heater: ${temp.heaterOn ? "🔥 Encendido" : "❄ Apagado"}"),
            if (temp.forcedOff)
              const Text(
                "Apagado total activo (force off)",
                style: TextStyle(color: Colors.red),
              ),
            if (temp.error != null)
              Text(
                "Error: ${temp.error}",
                style: const TextStyle(color: Colors.red),
              ),

            const Divider(height: 32),

            const Text("Configurar rango de temperatura"),
            const SizedBox(height: 8),

            Text("Mínimo: ${_newMin.toStringAsFixed(1)}°C"),
            Slider(
              value: _newMin,
              min: 5,
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

            Text("Máximo: ${_newMax.toStringAsFixed(1)}°C"),
            Slider(
              value: _newMax,
              min: _newMin + 1,
              max: 80,
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
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                onPressed: temp.isLoading
                    ? null
                    : () => controller.applyRange(_newMin, _newMax),
                child: const Text(
                  "Guardar rango",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    temp.autoEnabled ? Colors.red : Colors.green,
                  ),
                ),
                onPressed: controller.toggleAuto,
                icon: Icon(
                  temp.autoEnabled ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                ),
                label: Text(
                  temp.autoEnabled ? "Desactivar sensado" : "Activar sensado",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ElevatedButton(
            //   onPressed: controller.forceOff,
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            //   child: const Text("Apagado total"),
            // ),
          ],
        ),
      ),
    );
  }
}
