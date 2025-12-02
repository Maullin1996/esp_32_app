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
  late double _lowTh;
  late double _highTh;
  bool _initializedSliders = false;

  @override
  void initState() {
    super.initState();

    // configurar IP desde assignedDevicesProvider
    Future.microtask(() {
      final controller = ref.read(mq2ControllerProvider.notifier);
      final ip = ref.read(assignedDevicesProvider)["sensor_gas"];
      if (ip != null) {
        controller.setIp(ip);
      }
    });
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

    // Inicializar sliders una sola vez con los valores del estado
    if (!_initializedSliders) {
      _lowTh = state.lowTh.toDouble();
      _highTh = state.highTh.toDouble();
      _initializedSliders = true;
    }

    final (statusText, statusColor) = _statusInfo(state);

    return Scaffold(
      appBar: AppBar(title: Text("Sensor Gas MQ-2 (ESP: $ip)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lectura en vivo
              Center(
                child: Text(
                  'Gas: ${state.ppm} ppm',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Estado
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Estado: ', style: TextStyle(fontSize: 18)),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Modo automático: ${state.autoOn ? "ON" : "OFF"}   '
                  '|   Alarma: ${state.alarmOn ? "ENCENDIDA" : "APAGADA"}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              Center(
                child: Text(
                  'Modo sensado: ${state.sensingOn ? "ACTIVO" : "DESACTIVADO"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: state.sensingOn ? Colors.green : Colors.red,
                  ),
                ),
              ),

              if (state.error != null) ...[
                const SizedBox(height: 10),
                Text(state.error!, style: const TextStyle(color: Colors.red)),
              ],

              if (state.isSaving) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],

              const SizedBox(height: 16),

              // Botón MODO SENSADO
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
                        ? Icons.notifications_off
                        : Icons.notifications_active,
                  ),
                  onPressed: state.isSaving
                      ? null
                      : () => controller.toggleSensing(),
                  label: Text(
                    state.sensingOn
                        ? 'Desactivar modo sensado (silenciar alarmas)'
                        : 'Activar modo sensado',
                  ),
                ),
              ),

              if (!state.sensingOn) ...[
                const SizedBox(height: 6),
                const Text(
                  "⚠ Modo sensado desactivado: las alarmas automáticas y manuales "
                  "no se activarán, pero seguirás viendo la lectura de gas.",
                  style: TextStyle(color: Colors.orange),
                ),
              ],

              const SizedBox(height: 16),

              // Botón AUTO ON/OFF
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
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Botón MANUAL SOLO cuando auto OFF y sensing ON
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
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              const Text(
                "Umbrales de seguridad",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text('Umbral bajo (low_th): ${_lowTh.toInt()} ppm'),
              Slider(
                value: _lowTh,
                min: 0,
                max: 1000,
                divisions: 100,
                label: _lowTh.toInt().toString(),
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          // no dejar que low se pase de high
                          _lowTh = value.clamp(0, _highTh - 10);
                        });
                      },
              ),

              const SizedBox(height: 8),

              Text('Umbral alto (high_th): ${_highTh.toInt()} ppm'),
              Slider(
                value: _highTh,
                min: 0,
                max: 1000,
                divisions: 100,
                label: _highTh.toInt().toString(),
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          // no dejar que high sea menor que low
                          _highTh = value.clamp(_lowTh + 10, 1000);
                        });
                      },
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
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar umbrales"),
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
