import 'package:esp32_app/core/constants/app_constants.dart';
import 'package:esp32_app/features/devices/domain/entities/device_entity.dart';
import 'package:esp32_app/features/luces/presentation/providers/luces_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Luces18Page extends ConsumerStatefulWidget {
  final DeviceEntity device;
  const Luces18Page({super.key, required this.device});

  @override
  ConsumerState<Luces18Page> createState() => _Luces18PageState();
}

class _Luces18PageState extends ConsumerState<Luces18Page> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future.microtask(() {
        ref.read(lucesControllerProvider.notifier).setIp(widget.device.ip);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final luces = ref.watch(lucesControllerProvider);
    final controller = ref.read(lucesControllerProvider.notifier);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.device.name} (${widget.device.ip})"),
        ),
        body: luces.espIp.isEmpty
            ? const Center(child: Text("⛔ No se configuró la IP del ESP32"))
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: AppConstants.relaysCount,
                itemBuilder: (_, i) {
                  final on = luces.relays[i];
                  return GestureDetector(
                    onTap: () => controller.toggleRelay(i),
                    child: Column(
                      children: [
                        Icon(
                          on
                              ? Icons.lightbulb_circle_rounded
                              : Icons.lightbulb_circle_outlined,
                          color: on ? Colors.yellow.shade700 : Colors.grey,
                          size: 60,
                        ),
                        Text(
                          "Luz ${i + 1}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
