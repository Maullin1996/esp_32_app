import 'package:flutter/material.dart';

class IpInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;

  const IpInputCard({
    super.key,
    required this.controller,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('IP del ESP32 (vista en Serial):'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Ej: 192.168.43.100',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: onApply, child: const Text('OK')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
