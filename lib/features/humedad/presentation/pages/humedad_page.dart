import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/humedad_providers.dart';

class HumedadPage extends ConsumerStatefulWidget {
  const HumedadPage({super.key});

  @override
  ConsumerState<HumedadPage> createState() => _HumedadPageState();
}

class _HumedadPageState extends ConsumerState<HumedadPage> {
  final ipController = TextEditingController();
  final manualController = TextEditingController(text: "60");
  final minController = TextEditingController(text: "30");
  final maxController = TextEditingController(text: "60");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(humedadControllerProvider);
    final controller = ref.read(humedadControllerProvider.notifier);

    ref.listen(humedadControllerProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Humedad de suelos")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "IP del ESP32 (humedad)",
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
              "Humedad actual: ${state.humidity.toStringAsFixed(2)} %",
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "Bomba: ${state.pumpOn ? "ENCENDIDA" : "APAGADA"}",
              style: TextStyle(
                fontSize: 18,
                color: state.pumpOn ? Colors.blue : Colors.grey[800],
              ),
            ),

            if (state.isLoading) const LinearProgressIndicator(),

            const Divider(height: 40),

            const Text("Modo Manual", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            TextField(
              controller: manualController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Humedad objetivo (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final t = double.tryParse(manualController.text) ?? 60;
                controller.applyManual(t);
              },
              child: const Text("Aplicar Modo Manual"),
            ),

            const Divider(height: 40),

            const Text("Modo Rango Automático", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Mín (%)",
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
                      labelText: "Máx (%)",
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
                final mx = double.tryParse(maxController.text) ?? 60;
                controller.applyRange(mn, mx);
              },
              child: const Text("Aplicar Modo Rango"),
            ),

            const Divider(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
              onPressed: controller.stop,
              child: const Text("Apagar bomba / modo"),
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
