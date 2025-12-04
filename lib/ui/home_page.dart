import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:esp32_app/features/devices/presentation/pages/add_device_page.dart';
import 'package:esp32_app/features/devices/presentation/pages/manage_devices_page.dart';
import 'package:esp32_app/features/devices/presentation/providers/device_providers.dart';
import 'package:esp32_app/features/luces/presentation/pages/luces_page.dart';
import 'package:esp32_app/features/mq2/presentation/pages/mq2_page.dart';
import 'package:esp32_app/features/persiana/presentation/pages/persiana_page.dart';
import 'package:esp32_app/features/puerta/presentation/pages/door_page.dart';
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
    final devices = ref.watch(devicesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Automatizaciones"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddDevicePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageDevicesPage()),
              );
            },
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final dev = devices[i];

          return CustomCard(
            ctx: context,
            icon: _iconForType(dev.type),
            title: dev.name,
            page: _pageForType(dev),
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case "luces":
        return Icons.light_mode;
      case "temperatura":
        return Icons.thermostat;
      case "humedad":
        return Icons.grass;
      case "tanque":
        return Icons.bathroom;
      case "ventilacion":
        return Icons.air;
      case "sensor_gas":
        return Icons.warning;
      case "persiana":
        return Icons.curtains;
      case "puerta":
        return Icons.door_back_door;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _pageForType(DeviceEntity dev) {
    switch (dev.type) {
      case "temperatura":
        return TemperaturaPage(device: dev);
      case "luces":
        return Luces18Page(device: dev);
      case "humedad":
        return HumedadPage(device: dev);
      case "tanque":
        return TanquePage(device: dev);
      case "ventilacion":
        return VentilacionPage(device: dev);
      case "sensor_gas":
        return Mq2Page(device: dev);
      case "persiana":
        return PersianaPage(device: dev);
      case "puerta":
        return DoorPage(device: dev);
      default:
        return const Scaffold(body: Center(child: Text("Tipo no soportado")));
    }
  }
}
