// lib/features/mq2/presentation/pages/mq2_page.dart

import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:flutter/material.dart';

import 'package:esp32_app/features/mq2/presentation/providers/mq2_providers.dart';
import 'package:esp32_app/features/mq2/domain/entities/mq2_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Mq2Page extends ConsumerStatefulWidget {
  final DeviceEntity device;
  const Mq2Page({super.key, required this.device});

  @override
  ConsumerState<Mq2Page> createState() => _Mq2PageState();
}

class _Mq2PageState extends ConsumerState<Mq2Page> {
  double _highTh = 500;
  double _lowTh = 300;
  bool _hasLocalChanges = false;

  @override
  void initState() {
    super.initState();

    // Inicializa después de que el widget esté montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final state = ref.read(mq2ControllerProvider);
      setState(() {
        _highTh = state.highTh.toDouble();
        _lowTh = state.lowTh.toDouble();
      });

      ref.read(mq2ControllerProvider.notifier).setIp(widget.device.ip);
    });

    // Sincroniza sliders cuando cambien los umbrales remotamente
    // pero SOLO si no hay cambios locales pendientes
    ref.listenManual(mq2ControllerProvider.select((s) => (s.lowTh, s.highTh)), (
      prev,
      next,
    ) {
      if (mounted && !_hasLocalChanges) {
        setState(() {
          _lowTh = next.$1.toDouble();
          _highTh = next.$2.toDouble();
        });
      }
    });
  }

  // No necesitamos dispose, ref.onDispose del provider lo maneja

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mq2ControllerProvider);
    final controller = ref.read(mq2ControllerProvider.notifier);

    final (statusText, statusColor) = _statusInfo(state);
    final hasChanges =
        _lowTh.toInt() != state.lowTh || _highTh.toInt() != state.highTh;

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: Text("Sensor Gas MQ-2 (ESP: ${state.espIp})")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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

              // ESTADO
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

              // INFO MODO
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
                    fontWeight: FontWeight.w500,
                    color: state.sensingOn ? Colors.green : Colors.red,
                  ),
                ),
              ),

              // ERROR
              if (state.error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // LOADING
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
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(
                    state.sensingOn
                        ? Icons.volume_off
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Sensado desactivado: no se activarán alarmas automáticas o manuales.",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // BOTÓN MODE AUTO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.autoOn ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
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

              const SizedBox(height: 10),

              // BOTÓN MANUAL (solo SIN auto y CON sensado)
              if (!state.autoOn && state.sensingOn)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: state.alarmOn ? Colors.red : Colors.green,
                        width: 2,
                      ),
                    ),
                    onPressed: state.isSaving
                        ? null
                        : () => controller.setManualAlarm(!state.alarmOn),
                    child: Text(
                      state.alarmOn
                          ? 'Apagar alarma (manual)'
                          : 'Encender alarma (manual)',
                      style: TextStyle(
                        color: state.alarmOn ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // TÍTULO UMBRALES
              const Text(
                "Umbrales de seguridad",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // SLIDER LOW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Umbral bajo',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${_lowTh.toInt()} ppm',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Slider(
                activeColor: Colors.blue,
                value: _lowTh,
                min: 0,
                max: 1000,
                divisions: 100,
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          // Asegura que low siempre esté al menos 10 unidades por debajo de high
                          final maxLow = (_highTh - 10).clamp(0, 1000);
                          _lowTh = value.clamp(0, maxLow).toDouble();
                          _hasLocalChanges = true;
                        });
                      },
              ),

              const SizedBox(height: 8),

              // SLIDER HIGH
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Umbral alto',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${_highTh.toInt()} ppm',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Slider(
                activeColor: Colors.red,
                value: _highTh,
                min: 0,
                max: 1000,
                divisions: 100,
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        setState(() {
                          // Asegura que high siempre esté al menos 10 unidades por encima de low
                          final minHigh = (_lowTh + 10).clamp(0, 1000);
                          _highTh = value.clamp(minHigh, 1000).toDouble();
                          _hasLocalChanges = true;
                        });
                      },
              ),

              const SizedBox(height: 16),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: (state.isSaving || !hasChanges)
                      ? null
                      : () async {
                          // Guarda y luego resetea la bandera
                          await controller.saveThresholds(
                            _lowTh.toInt(),
                            _highTh.toInt(),
                          );

                          if (mounted) {
                            setState(() {
                              _hasLocalChanges = false;
                            });
                          }
                        },
                  icon: const Icon(Icons.save),
                  label: Text(hasChanges ? "Guardar umbrales" : "Sin cambios"),
                ),
              ),

              if (hasChanges) ...[
                const SizedBox(height: 6),
                const Text(
                  "Tienes cambios sin guardar",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _statusInfo(Mq2State state) {
    // Si el sensado está desactivado, ese es el estado más importante
    if (!state.sensingOn) {
      return ('Sensado OFF', Colors.grey);
    }

    // Evalúa el nivel de gas
    if (state.ppm < state.lowTh) {
      return ('Seguro', Colors.green);
    } else if (state.ppm <= state.highTh) {
      return ('Alerta', Colors.orange);
    } else {
      return ('Peligro', Colors.red);
    }
  }
}
