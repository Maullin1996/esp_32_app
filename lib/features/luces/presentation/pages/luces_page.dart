import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/luces_providers.dart';
import '../widgets/ip_input_card.dart';
import '../widgets/relay_grid.dart';

class Luces18Page extends ConsumerStatefulWidget {
  const Luces18Page({super.key});

  @override
  ConsumerState<Luces18Page> createState() => _Luces18PageState();
}

class _Luces18PageState extends ConsumerState<Luces18Page> {
  final ipController = TextEditingController();

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lucesControllerProvider);
    final controller = ref.read(lucesControllerProvider.notifier);

    ref.listen(lucesControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Luces – 18 relés (WiFi)')),
      body: Column(
        children: [
          IpInputCard(
            controller: ipController,
            onApply: () => controller.setIp(ipController.text),
          ),
          if (state.isSending) const LinearProgressIndicator(),
          Expanded(
            child: RelayGrid(
              relays: state.relays,
              onTap: controller.toggleRelay,
            ),
          ),
        ],
      ),
    );
  }
}
