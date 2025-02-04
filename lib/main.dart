import 'package:flutter/material.dart';
import 'package:iot_controller/features/bluetooth_discovery/bluetooth_discovery_page.dart';

void main() {
  runApp(const IotControllerApp());
}

class IotControllerApp extends StatelessWidget {
  const IotControllerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const BluetoothDiscoveryPage(),
    );
  }
}


