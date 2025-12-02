import 'package:esp32_app/core/mdns/mdns_scanner.dart';
import 'package:esp32_app/core/providers/assigned_devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

class MdnsScanPage extends ConsumerStatefulWidget {
  const MdnsScanPage({super.key});

  @override
  ConsumerState<MdnsScanPage> createState() => _MdnsScanPageState();
}

class _MdnsScanPageState extends ConsumerState<MdnsScanPage> {
  bool scanning = false;
  List<MdnsDiscoveredDevice> devices = [];

  // --- Obtiene la IP del celular ---

  Future<String?> _getWifiIp() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();

    if (ip == null) return null;
    if (!ip.startsWith("192.168.")) return null;

    return ip;
  }

  // --- Escanea la red LAN ---
  Future<List<String>> _scanSubnet(String base) async {
    List<String> found = [];

    for (int i = 1; i <= 254; i++) {
      final host = "$base.$i";

      try {
        final socket = await Socket.connect(
          host,
          80,
          timeout: const Duration(milliseconds: 150),
        ).timeout(const Duration(milliseconds: 200));

        socket.destroy();
        found.add(host);
      } catch (_) {
        // no responde → ignorar
      }
    }

    return found;
  }

  // --- Acción del botón "Buscar ESP32" ---
  Future<void> scan() async {
    setState(() {
      scanning = true;
      devices = [];
    });

    final wifiIp = await _getWifiIp();
    if (wifiIp == null) {
      setState(() => scanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo detectar la IP local")),
      );
      return;
    }

    final subnet = wifiIp.substring(0, wifiIp.lastIndexOf("."));
    final foundIps = await _scanSubnet(subnet);

    setState(() {
      scanning = false;
      devices = foundIps
          .map(
            (ip) =>
                MdnsDiscoveredDevice(hostname: "ESP32 ($ip)", ip: ip, port: 80),
          )
          .toList();
    });
  }

  // --- UI para asignar módulos ---
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
              _assignItem("Humedad Suelo", "humedad", dev),
              _assignItem("Tanque", "tanque", dev),
              _assignItem("Ventilación (DHT11)", "ventilacion", dev),
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

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar ESP32 en la red (LAN Scan)")),

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
}
