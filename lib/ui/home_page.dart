import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:esp32_app/features/devices/presentation/pages/add_device_page.dart';
import 'package:esp32_app/features/devices/presentation/pages/manage_devices_page.dart';
import 'package:esp32_app/features/luces/presentation/pages/luces_page.dart';
import 'package:esp32_app/features/temperatura/presentation/pages/temp_page.dart';
import 'package:esp32_app/features/ventilacion/presentation/pages/vent_page.dart';
import 'package:esp32_app/ui/widget/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/humedad/presentation/pages/humedad_page.dart';
import '../../features/tanque/presentation/pages/tanque_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assigned = ref.watch(assignedDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Automatizaciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddSimpleDevicePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageDevicesPage()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: assigned["luces"] != null ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: (assigned["luces"] != null)
                  ? CustomCard(
                      ctx: context,
                      icon: Icons.light_mode,
                      title: "Luces 18 Relés",
                      page: const Luces18Page(),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedOpacity(
              opacity: assigned["temperatura"] != null ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: (assigned["temperatura"] != null)
                  ? CustomCard(
                      ctx: context,
                      icon: Icons.thermostat_sharp,
                      title: "Temperatura / Agua",
                      page: const TemperaturaPage(),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedOpacity(
              opacity: assigned["humedad"] != null ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: (assigned["humedad"] != null)
                  ? CustomCard(
                      ctx: context,
                      icon: Icons.grid_4x4_rounded,
                      title: "Humedad de Suelo",
                      page: const HumedadPage(),
                    )
                  : SizedBox.shrink(),
            ),

            AnimatedOpacity(
              opacity: assigned["tanque"] != null ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: (assigned["tanque"] != null)
                  ? CustomCard(
                      ctx: context,
                      icon: Icons.bathroom_sharp,
                      title: "Tanque (ultrasonido)",
                      page: const TanquePage(),
                    )
                  : SizedBox.shrink(),
            ),

            AnimatedOpacity(
              opacity: assigned["ventilacion"] != null ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: (assigned["ventilacion"] != null)
                  ? CustomCard(
                      ctx: context,
                      icon: Icons.air_outlined,
                      title: "Temperatura (DHT11)",
                      page: const VentilacionPage(),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
