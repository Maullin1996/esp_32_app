import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/vent_providers.dart';
import '../controllers/vent_controller.dart';

class VentilacionPage extends ConsumerStatefulWidget {
  final DeviceEntity device;

  const VentilacionPage({super.key, required this.device});

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
        ref.read(ventControllerProvider.notifier).setIp(widget.device.ip);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vent = ref.watch(ventControllerProvider);
    final controller = ref.read(ventControllerProvider.notifier);

    if (vent.espIp.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay ESP32 configurado")),
      );
    }

    if (_newMin == 24) _newMin = vent.rangeMin;
    if (_newMax == 28) _newMax = vent.rangeMax;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.device.name} (${widget.device.ip})"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🌡 Sensores de Temperatura",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: vent.temps.length,
                  itemBuilder: (_, i) {
                    final temp = vent.temps[i];
                    final fanOn = vent.fans[i];
                    final name = (i < vent.names.length)
                        ? vent.names[i]
                        : "Sensor ${i + 1}";

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(
                          "Temperatura: ${temp.toStringAsFixed(1)} °C\n"
                          "Ventilador: ${fanOn ? "Encendido" : "Apagado"}",
                        ),

                        onLongPress: () =>
                            _showRenameDialog(context, controller, i, name),

                        trailing: vent.autoEnabled
                            ? const Text(
                                "AUTO",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )
                            : Switch(
                                value: fanOn,
                                onChanged: (_) => controller.toggleFanManual(i),
                              ),
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 32),

              const Text(
                "Configurar rango de temperatura global",
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
                  });
                },
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () => controller.applyRange(_newMin, _newMax),
                  child: const Text("Guardar rango"),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vent.autoEnabled
                        ? Colors.red
                        : Colors.green,
                  ),
                  onPressed: controller.toggleAuto,
                  icon: Icon(
                    vent.autoEnabled ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    vent.autoEnabled
                        ? "Desactivar automático"
                        : "Activar automático",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              if (vent.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  "Error: ${vent.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    VentController controller,
    int index,
    String currentName,
  ) {
    final ctrl = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Renombrar sensor"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: "Nombre",
            hintText: "Ej: Habitación, Cocina...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.renameSensor(index, ctrl.text);
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
