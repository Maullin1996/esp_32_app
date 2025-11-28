import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mdns/mdns_scanner.dart';

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

  void _showAssignDialog(MdnsDiscoveredDevice dev) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Asignar ${dev.hostname}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _assignItem("Luces", "luces", dev),
              _assignItem("Temperatura", "temperatura", dev),
              _assignItem("Humedad", "humedad", dev),
              _assignItem("Tanque", "tanque", dev),
            ],
          ),
        );
      },
    );
  }

  Widget _assignItem(String title, String moduleKey, MdnsDiscoveredDevice dev) {
    return ListTile(
      title: Text(title),
      onTap: () {
        ref.read(assignedDevicesProvider.notifier).assign(moduleKey, dev.ip);

        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Asignado a $title")));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final controller = ref.read(devicesControllerProvider.notifier);

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
                        child: const Text("Asignar"),
                        onPressed: () {
                          _showAssignDialog(dev);
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
  // String _inferType(String hostname) {
  //   if (hostname.contains("luces")) return "luces";
  //   if (hostname.contains("temp")) return "temperatura";
  //   if (hostname.contains("humedad")) return "humedad";
  //   if (hostname.contains("tanque")) return "tanque";
  //   return "desconocido";
  // }
}
