import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/tanque_providers.dart';

class TanquePage extends ConsumerStatefulWidget {
  const TanquePage({super.key});

  @override
  ConsumerState<TanquePage> createState() => _TanquePageState();
}

class _TanquePageState extends ConsumerState<TanquePage> {
  final ipController = TextEditingController();
  final manualController = TextEditingController(text: "90");
  final minController = TextEditingController(text: "20");
  final maxController = TextEditingController(text: "90");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tanqueControllerProvider);
    final controller = ref.read(tanqueControllerProvider.notifier);

    ref.listen(tanqueControllerProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Nivel de tanque (HC-SR04)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: "IP del ESP32 (tanque)",
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
              "Nivel actual: ${state.level.toStringAsFixed(2)} %",
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "Distancia: ${state.distanceCm.toStringAsFixed(2)} cm",
              style: const TextStyle(fontSize: 18),
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

            const Text(
              "Modo Manual (llenar hasta)",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: manualController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nivel objetivo (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final t = double.tryParse(manualController.text) ?? 90;
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
                final mn = double.tryParse(minController.text) ?? 20;
                final mx = double.tryParse(maxController.text) ?? 90;
                controller.applyRange(mn, mx);
              },
              child: const Text("Aplicar Modo Rango"),
            ),

            const Divider(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
              onPressed: controller.stop,
              child: const Text(
                "Apagar bomba / modo",
                style: TextStyle(color: Colors.white),
              ),
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
