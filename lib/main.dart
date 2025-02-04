import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_controller/shared/services/bluetooth_service.dart';
import 'package:iot_controller/features/bluetooth_discovery/bluetooth_discovery_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force portrait screen orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Init bluetooth service (Check valid environment for bluetooth)
  BluetoothService.initialize();
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


