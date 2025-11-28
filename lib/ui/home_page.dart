import 'package:esp32_app/features/luces/presentation/pages/luces_page.dart';
import 'package:esp32_app/features/temperatura/presentation/pages/temp_page.dart';
import 'package:esp32_app/ui/widget/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/humedad/presentation/pages/humedad_page.dart';
import '../../features/tanque/presentation/pages/tanque_page.dart';
import '../../features/devices/presentation/pages/devices_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agregar dispositivos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
            CustomCard(
              ctx: context,
              icon: Icons.light_mode,
              title: "Luces 18 Relés",
              page: const Luces18Page(),
            ),
            CustomCard(
              ctx: context,
              icon: Icons.thermostat_sharp,
              title: "Temperatura / Agua",
              page: const TemperaturaPage(),
            ),
            CustomCard(
              ctx: context,
              icon: Icons.grid_4x4_rounded,
              title: "Humedad de Suelo",
              page: const HumedadPage(),
            ),
            CustomCard(
              ctx: context,
              icon: Icons.bathroom_sharp,
              title: "Tanque (ultrasonido)",
              page: const TanquePage(),
            ),
          ],
        ),
      ),
    );
  }
}
