import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/assigned_devices_provider.dart';

class ManageDevicesPage extends ConsumerWidget {
  const ManageDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assigned = ref.watch(assignedDevicesProvider);
    final controller = ref.read(assignedDevicesProvider.notifier);

    final modules = {
      "luces": "Luces 18 Relés",
      "temperatura": "Temperatura",
      "humedad": "Humedad Suelo",
      "tanque": "Tanque",
      "ventilacion": "Ventilación",
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Gestionar ESP32")),
      body: ListView(
        children: modules.entries.map((entry) {
          final key = entry.key;
          final name = entry.value;
          final ip = assigned[key];

          return Card(
            child: ListTile(
              title: Text(name),
              subtitle: Text(ip != null ? "IP: $ip" : "Sin dispositivo"),
              trailing: ip != null
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.remove(key); // ELIMINA EL ESP32
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Eliminado $name")),
                        );
                      },
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
