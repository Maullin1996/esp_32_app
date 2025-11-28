import 'package:esp32_app/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';

void main() {
  runApp(const ProviderScope(child: Esp32App()));
}

class Esp32App extends StatelessWidget {
  const Esp32App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
