import 'package:esp32_app/features/devices/presentation/pages/mdns_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/device_providers.dart';
import 'add_device_page.dart';

class DevicesPage extends ConsumerWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(devicesControllerProvider);
    final controller = ref.read(devicesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Mis ESP32")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "scan",
            child: const Icon(Icons.wifi_find),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MdnsScanPage()),
              );
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddDevicePage()),
              );
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final d = devices[i];
          return ListTile(
            title: Text(d.name),
            subtitle: Text("${d.ip} — ${d.type}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.removeDevice(i),
            ),
            onTap: () {
              ref.read(selectedDeviceProvider.notifier).state = d;
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
