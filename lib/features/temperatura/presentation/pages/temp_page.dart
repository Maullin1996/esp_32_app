import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/temp_providers.dart';

class TempPage extends ConsumerStatefulWidget {
  const TempPage({super.key});

  @override
  ConsumerState<TempPage> createState() => _TempPageState();
}

class _TempPageState extends ConsumerState<TempPage> {
  final ipController = TextEditingController();
  final manualController = TextEditingController(text: "40");
  final minController = TextEditingController(text: "30");
  final maxController = TextEditingController(text: "35");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tempControllerProvider);
    final controller = ref.read(tempControllerProvider.notifier);

    ref.listen(tempControllerProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Control de Temperatura")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "IP del ESP32",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.setIp(ipController.text.trim());
              },
              child: const Text("Conectar"),
            ),

            const SizedBox(height: 20),

            Text(
              "Temperatura actual: ${state.temperature.toStringAsFixed(2)}°C",
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "Resistencia: ${state.heaterOn ? "ENCENDIDA" : "APAGADA"}",
              style: TextStyle(
                fontSize: 18,
                color: state.heaterOn ? Colors.red : Colors.green,
              ),
            ),

            const Divider(height: 40),

            // =========================
            // MODO MANUAL
            // =========================
            const Text("Modo Manual", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            TextField(
              controller: manualController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Temperatura objetivo (°C)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                final t = double.tryParse(manualController.text) ?? 40;
                controller.applyManual(t);
              },
              child: const Text("Aplicar Modo Manual"),
            ),

            const Divider(height: 40),

            // =========================
            // MODO RANGO
            // =========================
            const Text("Modo Rango Automático", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Mín (°C)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Máx (°C)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final mn = double.tryParse(minController.text) ?? 30;
                final mx = double.tryParse(maxController.text) ?? 35;

                controller.applyRange(mn, mx);
              },
              child: const Text("Aplicar Modo Rango"),
            ),

            const Divider(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
              onPressed: controller.stop,
              child: const Text("Apagar sistema"),
            ),

            const SizedBox(height: 20),

            Text(
              "Modo actual: ${state.mode}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
