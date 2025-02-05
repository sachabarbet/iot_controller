import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/services/mqtt_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Force portrait screen orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Init mqtt service
  final mqttService = MqttService();
  await mqttService.connect();

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
      home: const Scaffold(),
    );
  }
}
