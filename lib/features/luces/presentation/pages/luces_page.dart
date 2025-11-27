import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../devices/presentation/providers/device_providers.dart';
import 'package:http/http.dart' as http;

class Luces18Page extends ConsumerStatefulWidget {
  const Luces18Page({super.key});

  @override
  ConsumerState<Luces18Page> createState() => _Luces18PageState();
}

class _Luces18PageState extends ConsumerState<Luces18Page> {
  List<bool> relays = List.filled(18, false);

  Future<void> toggleRelay(int index) async {
    final device = ref.read(selectedDeviceProvider);
    if (device == null) return;

    final url = Uri.http(device.ip, "/relay", {
      "id": index.toString(),
      "state": relays[index] ? "0" : "1",
    });

    final res = await http.post(url);

    if (res.statusCode == 200) {
      setState(() => relays[index] = !relays[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(selectedDeviceProvider);

    if (device == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ Selecciona un ESP32 primero")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Luces (ESP: ${device.name})")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 18,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => toggleRelay(i),
            child: Container(
              decoration: BoxDecoration(
                color: relays[i]
                    ? Colors.yellow.shade700
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Luz ${i + 1}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
