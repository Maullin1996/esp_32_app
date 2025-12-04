import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/ventilacion/presentation/providers/vent_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VentilacionPage extends ConsumerStatefulWidget {
  const VentilacionPage({super.key});

  @override
  ConsumerState<VentilacionPage> createState() => _VentilacionPageState();
}

class _VentilacionPageState extends ConsumerState<VentilacionPage> {
  bool _initialized = false;
  double _newMin = 24;
  double _newMax = 28;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;

        final ip = ref.read(assignedDevicesProvider)["ventilacion"];
        if (ip != null) {
          ref.read(ventControllerProvider.notifier).setIp(ip);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vent = ref.watch(ventControllerProvider);
    final controller = ref.read(ventControllerProvider.notifier);

    final ip = ref.watch(assignedDevicesProvider)["ventilacion"];
    if (ip == null || vent.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Ventilación")),
      );
    }

    // Inicializar sliders una sola vez según el estado remoto
    _newMin = _newMin == 24 ? vent.rangeMin : _newMin;
    _newMax = _newMax == 28 ? vent.rangeMax : _newMax;

    return Scaffold(
      appBar: AppBar(title: Text("Ventilación (ESP: $ip)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Indicadores ----
            Text(
              "🌡 Temperatura: ${vent.temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              "Rango actual: "
              "${vent.rangeMin.toStringAsFixed(1)}°C – "
              "${vent.rangeMax.toStringAsFixed(1)}°C",
            ),
            Text("Sensado: ${vent.autoEnabled ? "Activado" : "Desactivado"}"),
            Text(
              "Aire acondicionado: "
              "${vent.fanOn ? "💨 Encendido" : "⛔ Apagado"}",
              style: TextStyle(
                color: vent.fanOn ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (vent.error != null)
              Text(
                "Error: ${vent.error}",
                style: const TextStyle(color: Colors.red),
              ),

            const Divider(height: 32),

            // ---- Configuración rango ----
            const Text(
              "Configurar rango de temperatura",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text("Mínimo: ${_newMin.toStringAsFixed(1)}°C"),
            Slider(
              value: _newMin,
              min: 10,
              max: _newMax - 1,
              onChanged: (v) {
                setState(() {
                  _newMin = v;
                  if (_newMax <= _newMin) _newMax = _newMin + 1;
                });
              },
            ),

            Text("Máximo: ${_newMax.toStringAsFixed(1)}°C"),
            Slider(
              value: _newMax,
              min: _newMin + 1,
              max: 50,
              onChanged: (v) {
                setState(() {
                  _newMax = v;
                  if (_newMax <= _newMin) _newMin = _newMax - 1;
                });
              },
            ),

            Center(
              child: ElevatedButton(
                onPressed: () => controller.applyRange(_newMin, _newMax),
                child: const Text(
                  "Guardar rango",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---- Botón de sensado ----
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: vent.autoEnabled ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                onPressed: controller.toggleAuto,
                icon: Icon(
                  vent.autoEnabled ? Icons.pause_circle : Icons.play_circle,
                  size: 28,
                  color: Colors.white,
                ),
                label: Text(
                  vent.autoEnabled ? "Desactivar sensado" : "Activar sensado",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---- Botón manual AC (solo si auto OFF) ----
            if (!vent.autoEnabled)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vent.fanOn ? Colors.orange : Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  onPressed: controller.toggleFanManual,
                  icon: Icon(
                    vent.fanOn ? Icons.power_settings_new : Icons.ac_unit,
                    size: 26,
                    color: Colors.white,
                  ),
                  label: Text(
                    vent.fanOn
                        ? "Apagar aire acondicionado"
                        : "Encender aire acondicionado",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
