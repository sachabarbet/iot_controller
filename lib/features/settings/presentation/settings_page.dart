import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mqtt_config_provider.dart';

class SettingsPage extends ConsumerWidget  {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mqttConfig = ref.watch(mqttConfigProvider);
    final notifier = ref.read(mqttConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("MQTT Settings")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: mqttConfig.brokerHost),
              decoration: InputDecoration(labelText: "Broker Host"),
              onChanged: (value) => notifier.saveConfig(mqttConfig.copyWith(brokerHost: value)),
            ),
            SwitchListTile(
              title: Text("Secure Connection"),
              value: mqttConfig.isSecure,
              onChanged: (value) => notifier.saveConfig(mqttConfig.copyWith(isSecure: value)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => notifier.saveConfig(mqttConfig),
              child: Text("Save Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
