import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mdns/mdns_scanner.dart';
import '../providers/device_providers.dart';
import '../../domain/entities/device_entity.dart';

class MdnsScanPage extends ConsumerStatefulWidget {
  const MdnsScanPage({super.key});

  @override
  ConsumerState<MdnsScanPage> createState() => _MdnsScanPageState();
}

class _MdnsScanPageState extends ConsumerState<MdnsScanPage> {
  bool scanning = false;
  List<MdnsDiscoveredDevice> devices = [];

  Future<void> scan() async {
    setState(() {
      scanning = true;
      devices = [];
    });

    final scanner = MdnsScanner();
    final results = await scanner.discoverEsp32();

    setState(() {
      scanning = false;
      devices = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(devicesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Buscar ESP32 en la red (mDNS)")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: scanning ? null : scan,
              icon: const Icon(Icons.search),
              label: Text(scanning ? "Buscando..." : "Buscar ESP32"),
            ),

            const SizedBox(height: 20),

            if (scanning) const Center(child: CircularProgressIndicator()),

            if (!scanning && devices.isEmpty)
              const Text("No se encontraron dispositivos"),

            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (_, i) {
                  final dev = devices[i];

                  return Card(
                    child: ListTile(
                      title: Text(dev.hostname),
                      subtitle: Text(dev.ip),
                      trailing: ElevatedButton(
                        child: const Text("Agregar"),
                        onPressed: () async {
                          // Detectar tipo según nombre mDNS
                          final type = _inferType(dev.hostname);

                          final newDevice = DeviceEntity(
                            name: dev.hostname,
                            ip: dev.hostname, // usamos mDNS directamente
                            type: type,
                          );

                          await controller.addDevice(newDevice);

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${dev.hostname} agregado")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Detecta el tipo según el nombre del módulo
  String _inferType(String hostname) {
    if (hostname.contains("luces")) return "luces";
    if (hostname.contains("temp")) return "temperatura";
    if (hostname.contains("humedad")) return "humedad";
    if (hostname.contains("tanque")) return "tanque";
    return "desconocido";
  }
}
