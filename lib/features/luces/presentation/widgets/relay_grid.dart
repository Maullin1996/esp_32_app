import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class RelayGrid extends StatelessWidget {
  final List<bool> relays;
  final void Function(int index) onTap;

  const RelayGrid({super.key, required this.relays, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: AppConstants.relaysCount,
      itemBuilder: (_, i) {
        final on = relays[i];

        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            decoration: BoxDecoration(
              color: on ? Colors.yellow.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('Luz ${i + 1}', style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      },
    );
  }
}
