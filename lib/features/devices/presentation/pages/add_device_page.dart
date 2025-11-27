import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/device_providers.dart';
import '../../domain/entities/device_entity.dart';

class AddDevicePage extends ConsumerStatefulWidget {
  const AddDevicePage({super.key});

  @override
  ConsumerState<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends ConsumerState<AddDevicePage> {
  final nameCtrl = TextEditingController();
  final ipCtrl = TextEditingController();
  String type = "luces";

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(devicesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Agregar ESP32")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: ipCtrl,
              decoration: const InputDecoration(labelText: "IP"),
            ),

            const SizedBox(height: 10),

            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: "luces", child: Text("Luces 18 relés")),
                DropdownMenuItem(
                  value: "temperatura",
                  child: Text("Temperatura"),
                ),
                DropdownMenuItem(
                  value: "humedad",
                  child: Text("Humedad Suelo"),
                ),
                DropdownMenuItem(value: "tanque", child: Text("Tanque")),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final d = DeviceEntity(
                  name: nameCtrl.text.trim(),
                  ip: ipCtrl.text.trim(),
                  type: type,
                );

                await controller.addDevice(d);

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
