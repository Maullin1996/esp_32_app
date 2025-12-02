import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/assigned_devices_provider.dart';

class AddSimpleDevicePage extends ConsumerStatefulWidget {
  const AddSimpleDevicePage({super.key});

  @override
  ConsumerState<AddSimpleDevicePage> createState() =>
      _AddSimpleDevicePageState();
}

class _AddSimpleDevicePageState extends ConsumerState<AddSimpleDevicePage> {
  final ipCtrl = TextEditingController();
  String module = "luces";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar ESP32")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecciona el tipo de módulo:",
              style: TextStyle(fontSize: 16),
            ),

            DropdownButton<String>(
              value: module,
              items: const [
                DropdownMenuItem(value: "luces", child: Text("Luces 18 Relés")),
                DropdownMenuItem(
                  value: "temperatura",
                  child: Text("Temperatura/Agua"),
                ),
                DropdownMenuItem(
                  value: "humedad",
                  child: Text("Humedad Suelo"),
                ),
                DropdownMenuItem(value: "tanque", child: Text("Tanque")),
                DropdownMenuItem(
                  value: "ventilacion",
                  child: Text("Ventilación (DHT11)"),
                ),
                DropdownMenuItem(
                  value: "sensor_gas",
                  child: Text("Sensor Gas MQ-2"),
                ),
              ],
              onChanged: (v) => setState(() => module = v!),
            ),

            const SizedBox(height: 20),
            const Text(
              "IP del ESP32 (IP estática):",
              style: TextStyle(fontSize: 16),
            ),

            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              controller: ipCtrl,
              decoration: const InputDecoration(
                hintText: "Ej: 192.168.1.120",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final ip = ipCtrl.text.trim();
                if (ip.isEmpty) return;

                ref.read(assignedDevicesProvider.notifier).assign(module, ip);

                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Asignado a $module")));
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
