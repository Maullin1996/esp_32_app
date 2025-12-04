import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:esp32_app/features/persiana/presentation/providers/persiana_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersianaPage extends ConsumerStatefulWidget {
  final DeviceEntity device;
  const PersianaPage({super.key, required this.device});

  @override
  ConsumerState<PersianaPage> createState() => _PersianaPageState();
}

class _PersianaPageState extends ConsumerState<PersianaPage> {
  bool _initialized = false;

  double _newMin = 24;
  double _newMax = 28;
  double _newPwm = 180;
  double _newTimeOpen = 1500;
  double _newTimeClose = 1500;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;

        ref.read(persianaControllerProvider.notifier).setIp(widget.device.ip);
      });
    }
  }

  Color _statusColor(String motorState) {
    switch (motorState) {
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
    final state = ref.watch(persianaControllerProvider);
    final controller = ref.read(persianaControllerProvider.notifier);

    if (state.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 asignado a Persiana")),
      );
    }

    // Sincronizar sliders SOLO la primera vez
    _newMin = _newMin == 24 ? state.rangeMin : _newMin;
    _newMax = _newMax == 28 ? state.rangeMax : _newMax;
    _newPwm = _newPwm == 180 ? state.pwm.toDouble() : _newPwm;
    _newTimeOpen = _newTimeOpen == 1500
        ? state.timeOpenMs.toDouble()
        : _newTimeOpen;
    _newTimeClose = _newTimeClose == 1500
        ? state.timeCloseMs.toDouble()
        : _newTimeClose;

    final isAuto = state.autoEnabled;

    return Scaffold(
      appBar: AppBar(title: Text("Persiana (ESP: ${state.espIp})")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- ESTADO -----
            Text(
              "🌡 Temperatura: ${state.temperature.toStringAsFixed(1)} °C",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              "Modo: ${isAuto ? "Automático" : "Manual"}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAuto ? Colors.blue : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text("Motor: "),
                Text(
                  state.motorState,
                  style: TextStyle(
                    color: _statusColor(state.motorState),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text("Última acción: ${state.lastAction}"),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const Divider(height: 32),

            // ----- RANGO AUTO -----
            const Text(
              "Rango de temperatura (modo AUTO)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Mínimo: ${_newMin.toStringAsFixed(1)} °C"),
            Slider(
              value: _newMin,
              min: 10,
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
            Text("Máximo: ${_newMax.toStringAsFixed(1)} °C"),
            Slider(
              value: _newMax,
              min: _newMin + 1,
              max: 50,
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
                onPressed: () => controller.applyRange(_newMin, _newMax),
                child: const Text(
                  "Guardar rango",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const Divider(height: 32),

            // ----- PWM -----
            const Text(
              "Velocidad (PWM)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "PWM: ${_newPwm.toInt()} (aprox. ${(100 * _newPwm / 255).toStringAsFixed(0)}%)",
            ),
            Slider(
              value: _newPwm,
              min: 0,
              max: 255,
              onChanged: (v) {
                setState(() {
                  _newPwm = v;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => controller.applyPwm(_newPwm.toInt()),
                child: const Text(
                  "Guardar PWM",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const Divider(height: 32),

            // ----- TIEMPOS AUTO -----
            const Text(
              "Tiempos en AUTO (ms)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Tiempo abrir: ${_newTimeOpen.toInt()} ms"),
            Slider(
              value: _newTimeOpen,
              min: 200,
              max: 20000,
              onChanged: (v) {
                setState(() {
                  _newTimeOpen = v;
                });
              },
            ),
            Text("Tiempo cerrar: ${_newTimeClose.toInt()} ms"),
            Slider(
              value: _newTimeClose,
              min: 200,
              max: 20000,
              onChanged: (v) {
                setState(() {
                  _newTimeClose = v;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => controller.applyTiming(
                  _newTimeOpen.toInt(),
                  _newTimeClose.toInt(),
                ),
                child: const Text(
                  "Guardar tiempos",
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----- CONTROLES MANUALES (solo cuando auto OFF) -----
            if (!isAuto) ...[
              const Text(
                "Control manual (mantén presionado)",
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
                    onDown: () => controller.startManualOpen(),
                    onUp: () => controller.stopManual(),
                  ),
                  _pressHoldButton(
                    context: context,
                    label: "Cerrar",
                    color: Colors.orange,
                    icon: Icons.arrow_downward,
                    onDown: () => controller.startManualClose(),
                    onUp: () => controller.stopManual(),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
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
