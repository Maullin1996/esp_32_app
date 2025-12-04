// lib/features/mq2/presentation/pages/mq2_page.dart

import 'package:flutter/material.dart';

import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/mq2/presentation/providers/mq2_providers.dart';
import 'package:esp32_app/features/mq2/domain/entities/mq2_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Mq2Page extends ConsumerStatefulWidget {
  const Mq2Page({super.key});

  @override
  ConsumerState<Mq2Page> createState() => _Mq2PageState();
}

class _Mq2PageState extends ConsumerState<Mq2Page> {
  bool _initialized = false;

  // Sliders
  double _lowTh = 0;
  double _highTh = 0;
  bool _userIsMovingSlider = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future(() {
        if (!mounted) return;

        final ip = ref.read(assignedDevicesProvider)["sensor_gas"];
        if (ip != null) {
          ref.read(mq2ControllerProvider.notifier).setIp(ip);
        }
      });
    }
  }

  // Sincroniza sliders solo cuando el usuario NO los está moviendo
  void _syncSliders(Mq2State state) {
    if (!_userIsMovingSlider) {
      _lowTh = state.lowTh.toDouble();
      _highTh = state.highTh.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mq2ControllerProvider);
    final controller = ref.read(mq2ControllerProvider.notifier);

    final ip = ref.watch(assignedDevicesProvider)["sensor_gas"];

    if (ip == null) {
      return const Scaffold(
        body: Center(
          child: Text("⛔ No hay ESP32 asignado al módulo Sensor Gas MQ-2"),
        ),
      );
    }

    // ← este sync evita FREEZE
    _syncSliders(state);

    final (statusText, statusColor) = _statusInfo(state);

    return Scaffold(
      appBar: AppBar(title: Text("Sensor Gas MQ-2 (ESP: $ip)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LECTURA EN VIVO
              Center(
                child: Text(
                  'Gas: ${state.ppm} ppm',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Estado: ', style: TextStyle(fontSize: 20)),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  'Auto: ${state.autoOn ? "ON" : "OFF"}'
                  ' | Alarma: ${state.alarmOn ? "ENCENDIDA" : "APAGADA"}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              Center(
                child: Text(
                  'Modo sensado: ${state.sensingOn ? "ACTIVO" : "DESACTIVADO"}',
                  style: TextStyle(
                    fontSize: 16,
                    color: state.sensingOn ? Colors.green : Colors.red,
                  ),
                ),
              ),

              if (state.error != null) ...[
                const SizedBox(height: 8),
                Text(state.error!, style: const TextStyle(color: Colors.red)),
              ],

              if (state.isSaving) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],

              const SizedBox(height: 16),

              // BOTÓN MODO SENSADO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.sensingOn
                        ? Colors.red
                        : Colors.green,
                  ),
                  icon: Icon(
                    state.sensingOn
                        ? Icons.volume_off
                        : Icons.notifications_active,
                    color: Colors.white,
                  ),
                  onPressed: state.isSaving
                      ? null
                      : () => controller.toggleSensing(),
                  label: Text(
                    state.sensingOn
                        ? 'Desactivar modo sensado (silenciar alarmas)'
                        : 'Activar modo sensado',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              if (!state.sensingOn) ...[
                const SizedBox(height: 6),
                const Text(
                  "⚠ Sensado desactivado: no se activarán alarmas automáticas o manuales.",
                  style: TextStyle(color: Colors.orange),
                ),
              ],

              const SizedBox(height: 16),

              // BOTÓN MODE AUTO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.autoOn ? Colors.red : Colors.green,
                  ),
                  onPressed: state.isSaving
                      ? null
                      : () => controller.toggleAuto(),
                  child: Text(
                    state.autoOn
                        ? 'Desactivar modo automático'
                        : 'Activar modo automático',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // BOTÓN MANUAL (solo SIN auto y CON sensado)
              if (!state.autoOn && state.sensingOn)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: state.isSaving
                        ? null
                        : () => controller.setManualAlarm(!state.alarmOn),
                    child: Text(
                      state.alarmOn
                          ? 'Apagar alarma (manual)'
                          : 'Encender alarma (manual)',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              const Text(
                "Umbrales de seguridad",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // SLIDER LOW
              Text('Umbral bajo (low_th): ${_lowTh.toInt()} ppm'),
              Slider(
                value: _lowTh,
                min: 0,
                max: 1000,
                divisions: 100,
                onChangeStart: (_) => _userIsMovingSlider = true,
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _lowTh = value.clamp(0, _highTh - 10);
                        });
                      },
                onChangeEnd: (_) => _userIsMovingSlider = false,
              ),

              const SizedBox(height: 8),

              // SLIDER HIGH
              Text('Umbral alto (high_th): ${_highTh.toInt()} ppm'),
              Slider(
                value: _highTh,
                min: 0,
                max: 1000,
                divisions: 100,
                onChangeStart: (_) => _userIsMovingSlider = true,
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _highTh = value.clamp(_lowTh + 10, 1000);
                        });
                      },
                onChangeEnd: (_) => _userIsMovingSlider = false,
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isSaving
                      ? null
                      : () => controller.saveThresholds(
                          _lowTh.toInt(),
                          _highTh.toInt(),
                        ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Guardar umbrales",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _statusInfo(Mq2State state) {
    if (state.ppm < state.lowTh) {
      return ('Seguro', Colors.green);
    } else if (state.ppm <= state.highTh) {
      return ('Alerta', Colors.orange);
    } else {
      return ('Peligro', Colors.red);
    }
  }
}
