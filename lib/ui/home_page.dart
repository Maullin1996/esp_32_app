import 'package:esp32_app/features/luces/presentation/pages/luces_page.dart';
import 'package:esp32_app/features/temperatura/presentation/pages/temp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/devices/presentation/providers/device_providers.dart';
import '../../features/humedad/presentation/pages/humedad_page.dart';
import '../../features/tanque/presentation/pages/tanque_page.dart';
import '../../features/devices/presentation/pages/devices_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget moduleButton(BuildContext ctx, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDeviceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selected == null
              ? "Home (sin dispositivo seleccionado)"
              : "Home — ${selected.name}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DevicesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            moduleButton(context, "Luces 18 Relés", const Luces18Page()),
            moduleButton(
              context,
              "Temperatura / Agua",
              const TemperaturaPage(),
            ),
            moduleButton(context, "Humedad de Suelo", const HumedadPage()),
            moduleButton(context, "Tanque (ultrasonido)", const TanquePage()),
          ],
        ),
      ),
    );
  }
}
