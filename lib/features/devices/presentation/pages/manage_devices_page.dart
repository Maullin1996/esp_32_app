import 'package:esp32_app/features/devices/presentation/providers/device_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageDevicesPage extends ConsumerWidget {
  const ManageDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(devicesControllerProvider);
    final controller = ref.read(devicesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Gestionar dispositivos")),
      body: devices.isEmpty
          ? const Center(child: Text("No hay dispositivos registrados"))
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (_, i) {
                final dev = devices[i];

                return Card(
                  child: ListTile(
                    leading: Icon(_iconForType(dev.type), size: 32),
                    title: Text(dev.name),
                    subtitle: Text("${dev.type} • IP: ${dev.ip}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.removeDevice(i);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${dev.name} eliminado")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case "temperatura":
        return Icons.thermostat;
      case "humedad":
        return Icons.grass;
      case "tanque":
        return Icons.water;
      case "ventilacion":
        return Icons.air;
      case "sensor_gas":
        return Icons.warning;
      case "persiana":
        return Icons.curtains;
      case "puerta":
        return Icons.door_back_door;
      default:
        return Icons.device_unknown;
    }
  }
}
