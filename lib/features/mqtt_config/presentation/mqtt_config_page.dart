import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../shared/mqtt_config/presentation/mqtt_config_provider.dart';

class MqttConfigPage extends ConsumerStatefulWidget {
  const MqttConfigPage({super.key});

  @override
  ConsumerState<MqttConfigPage> createState() => _MqttConfigPageState();
}

class _MqttConfigPageState extends ConsumerState<MqttConfigPage> {
  late TextEditingController brokerHostController;
  late TextEditingController brokerPortController;
  late TextEditingController clientIdController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final mqttConfig = ref.read(mqttConfigProvider);

    brokerHostController = TextEditingController(text: mqttConfig.brokerHost);
    brokerPortController =
        TextEditingController(text: mqttConfig.brokerPort.toString());
    clientIdController =
        TextEditingController(text: mqttConfig.clientIdentifier);
    usernameController = TextEditingController(text: mqttConfig.username);
    passwordController = TextEditingController(text: mqttConfig.password);
  }

  @override
  void dispose() {
    brokerHostController.dispose();
    brokerPortController.dispose();
    clientIdController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String parseConnectionStatus(MqttConnectionState state) {
    switch (state) {
      case MqttConnectionState.connected:
        return 'Connected';
      case MqttConnectionState.connecting:
        return 'Connecting';
      case MqttConnectionState.disconnected:
        return 'Disconnected';
      case MqttConnectionState.disconnecting:
        return 'Disconnecting';
      case MqttConnectionState.faulted:
        return 'Faulted';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqttConfig = ref.watch(mqttConfigProvider);
    final connectionState = ref.watch(mqttServiceProvider);
    final notifier = ref.read(mqttConfigProvider.notifier);
    ref.listen(mqttConfigProvider, (_, next) {
      brokerHostController.text = next.brokerHost;
      brokerPortController.text = next.brokerPort.toString();
      clientIdController.text = next.clientIdentifier;
      usernameController.text = next.username;
      passwordController.text = next.password;
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Mqtt settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            // MQTT broker state
            Text(
              'MQTT Broker state is: ${parseConnectionStatus(connectionState)}',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Broker host'),
              controller: brokerHostController,
              onChanged: (value) =>
                  notifier.saveConfig(mqttConfig.copyWith(brokerHost: value)),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Broker port'),
              controller: brokerPortController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsedPort = int.tryParse(value) ?? mqttConfig.brokerPort;
                notifier.saveConfig(
                  mqttConfig.copyWith(brokerPort: parsedPort),
                );
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Client ID'),
              controller: clientIdController,
              onChanged: (value) => notifier.saveConfig(
                mqttConfig.copyWith(clientIdentifier: value),
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              controller: usernameController,
              onChanged: (value) => notifier.saveConfig(
                mqttConfig.copyWith(username: value),
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              controller: passwordController,
              obscureText: true,
              onChanged: (value) => notifier.saveConfig(
                mqttConfig.copyWith(password: value),
              ),
            ),
            SwitchListTile(
              title: const Text('Secure connection'),
              value: mqttConfig.isSecure,
              onChanged: (value) => notifier.saveConfig(
                mqttConfig.copyWith(isSecure: value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),
            ElevatedButton(
              onPressed: () => notifier.connect(context),
              child: const Text('Connect to MQTT Broker'),
            ),
          ],
        ),
      ),
    );
  }
}
