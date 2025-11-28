import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/luces/presentation/controllers/luces_controller.dart';
import 'package:esp32_app/features/luces/presentation/providers/luces_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Luces18Page extends ConsumerStatefulWidget {
  const Luces18Page({super.key});

  @override
  ConsumerState<Luces18Page> createState() => _Luces18PageState();
}

class _Luces18PageState extends ConsumerState<Luces18Page> {
  List<bool> relays = List.filled(18, false);
  late LucesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(lucesControllerProvider.notifier);

    Future.microtask(() {
      final ip = ref.read(assignedDevicesProvider)["luces"];
      if (ip != null) {
        _controller.setIp(ip);
      }
    });
  }

  Future<void> toggleRelay(int index) async {
    final ip = ref.read(assignedDevicesProvider)["luces"];
    if (ip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay ESP32 asignado a Luces")),
      );
      return;
    }

    final url = Uri.http(ip, "/relay", {
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
    final ip = ref.watch(assignedDevicesProvider)["luces"];

    if (ip == null) {
      return const Scaffold(
        body: Center(child: Text("⛔ No hay un ESP32 asignado a Luces")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Luces (ESP: $ip)")),
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Luz ${i + 1}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
