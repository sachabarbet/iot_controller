import 'package:flutter/material.dart';

class BluetoothDiscoveryPage extends StatelessWidget {
  const BluetoothDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Discovery'),
      ),
      body: const Center(
        child: Text('Bluetooth Discovery Page'),
      ),
    );
  }
}