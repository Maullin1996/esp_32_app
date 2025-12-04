import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/puerta/presentation/providers/door_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoorPage extends ConsumerStatefulWidget {
  const DoorPage({super.key});

  @override
  ConsumerState<DoorPage> createState() => _DoorPageState();
}

class _DoorPageState extends ConsumerState<DoorPage> {
  bool _initialized = false;
  double _newThreshold = 40;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;
        final ip = ref.read(assignedDevicesProvider)["puerta"];
        if (ip != null) {
          ref.read(doorControllerProvider.notifier).setIp(ip);
        }
      });
    }
  }

  Color _stateColor(String state) {
    switch (state) {
      case "opening":
        return Colors.green;
      case "closing":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doorControllerProvider);
    final controller = ref.read(doorControllerProvider.notifier);
    final ip = ref.watch(assignedDevicesProvider)["puerta"];

    if (ip == null || state.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Puerta")),
      );
    }

    _newThreshold = _newThreshold == 40
        ? state.threshold.toDouble()
        : _newThreshold;

    final isAuto = state.autoEnabled;
    final isDay = state.lux >= state.threshold;

    return Scaffold(
      appBar: AppBar(title: Text("Puerta automática (ESP: $ip)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- ESTADO -----
            Text(
              "💡 Luz: ${state.lux.toStringAsFixed(1)} %",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              "Ambiente: ${isDay ? "DÍA" : "NOCHE"}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDay ? Colors.orange : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Estado motor: "),
                Text(
                  state.state,
                  style: TextStyle(
                    color: _stateColor(state.state),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text("Final abierto: ${state.fullyOpen ? "✅" : "❌"}"),
            Text("Final cerrado: ${state.fullyClosed ? "✅" : "❌"}"),
            const SizedBox(height: 8),
            Text(
              "Modo: ${isAuto ? "Automático (día/noche)" : "Manual"}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAuto ? Colors.blue : Colors.grey[800],
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const Divider(height: 32),

            // ----- UMBRAL LUZ -----
            const Text(
              "Umbral de luz para AUTO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Umbral actual: ${state.threshold} %"),
            const SizedBox(height: 4),
            Text("Nuevo umbral: ${_newThreshold.toInt()} %"),
            Slider(
              value: _newThreshold,
              min: 0,
              max: 100,
              onChanged: (v) {
                setState(() {
                  _newThreshold = v;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    controller.applyThreshold(_newThreshold.toInt()),
                child: const Text(
                  "Guardar umbral",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----- BOTÓN AUTO ON/OFF -----
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAuto ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                onPressed: controller.toggleAuto,
                icon: Icon(
                  isAuto ? Icons.pause_circle : Icons.play_circle,
                  size: 28,
                  color: Colors.white,
                ),
                label: Text(
                  isAuto ? "Desactivar automático" : "Activar automático",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----- CONTROLES MANUALES -----
            if (!isAuto) ...[
              const Text(
                "Control manual de puerta (mantén presionado)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _pressHoldButton(
                    context: context,
                    label: "Abrir",
                    color: Colors.blue,
                    icon: Icons.arrow_upward,
                    onDown: () => controller.startOpen(),
                    onUp: () => controller.stopManual(),
                  ),
                  _pressHoldButton(
                    context: context,
                    label: "Cerrar",
                    color: Colors.orange,
                    icon: Icons.arrow_downward,
                    onDown: () => controller.startClose(),
                    onUp: () => controller.stopManual(),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Text(
                "Al soltar el botón, la puerta se detiene.\nLos finales de carrera evitan sobrecarrera.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pressHoldButton({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onDown,
    required VoidCallback onUp,
  }) {
    return Listener(
      onPointerDown: (_) => onDown(),
      onPointerUp: (_) => onUp(),
      onPointerCancel: (_) => onUp(),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
