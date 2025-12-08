import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:esp32_app/features/devices/presentation/providers/device_providers.dart';
import 'package:esp32_app/features/devices/presentation/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDevicePage extends ConsumerStatefulWidget {
  const AddDevicePage({super.key});

  @override
  ConsumerState<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends ConsumerState<AddDevicePage> {
  final nameCtrl = TextEditingController();
  final ipCtrl = TextEditingController();
  String module = "temperatura"; // valor inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar dispositivo ESP32")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextFormField(
                controller: nameCtrl,
                labelText: "Nombre del dispositivo",
              ),
              const SizedBox(height: 12),

              DropdownButton<String>(
                value: module,
                items: const [
                  DropdownMenuItem(
                    value: "temperatura",
                    child: Text("Temperatura / Agua"),
                  ),
                  DropdownMenuItem(value: "luces", child: Text("Luces")),
                  DropdownMenuItem(
                    value: "humedad",
                    child: Text("Humedad Suelo"),
                  ),
                  DropdownMenuItem(
                    value: "tanque",
                    child: Text("Tanque (ultrasonido)"),
                  ),
                  DropdownMenuItem(
                    value: "ventilacion",
                    child: Text("Ventilación (DHT11)"),
                  ),
                  DropdownMenuItem(
                    value: "puerta",
                    child: Text("Puerta Automática"),
                  ),
                  DropdownMenuItem(
                    value: "persiana",
                    child: Text("Persiana Gallinero"),
                  ),
                  DropdownMenuItem(
                    value: "sensor_gas",
                    child: Text("Sensor MQ-2"),
                  ),
                ],
                onChanged: (v) => setState(() => module = v!),
              ),

              const SizedBox(height: 12),

              CustomTextFormField(
                controller: ipCtrl,
                labelText: "IP del ESP32 (estática)",
                hint: "192.168.1.120",
                keyboard: TextInputType.numberWithOptions(),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final ip = ipCtrl.text.trim();

                  if (name.isEmpty || ip.isEmpty) return;

                  final device = DeviceEntity(name: name, ip: ip, type: module);

                  ref
                      .read(devicesControllerProvider.notifier)
                      .addDevice(device);

                  Navigator.pop(context);
                },
                child: const Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
