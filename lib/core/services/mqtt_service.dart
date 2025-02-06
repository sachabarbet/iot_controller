import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../entities/mqtt_config_entity.dart';
import '../repositories/mqtt_config_repository.dart';

class MqttService extends StateNotifier<MqttConnectionState> {
  late MqttServerClient client;
  late MqttConfig config;

  MqttService() : super(MqttConnectionState.disconnected) {
    loadConfig();
    _loadClient();
  }

  void loadConfig() {
    config = MqttRepository().loadMqttConfig();
  }

  void _loadClient() {
    client = MqttServerClient(config.brokerHost, config.clientIdentifier);
    client.port = config.brokerPort;
    client.keepAlivePeriod = 20;
    client.logging(on: true);

    if (config.isSecure && config.tlsCertificatePath.isNotEmpty) {
      client.secure = true;
      client.setProtocolV311();
    }

    client.onConnected = () {
      state = MqttConnectionState.connected; // Notify UI
    };

    client.onDisconnected = () {
      state = MqttConnectionState.disconnected; // Notify UI
    };

    client.onSubscribed = (String topic) {
      print('Subscribed to: $topic');
    };
  }

  Future<void> connect() async {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print("Already connected to MQTT");
      return;
    }

    if (config.isSecure && config.tlsCertificatePath.isNotEmpty) {
      final context = SecurityContext.defaultContext;
      final certData = await rootBundle.load(config.tlsCertificatePath);
      context.setTrustedCertificatesBytes(certData.buffer.asUint8List());
      client.securityContext = context;
    }

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(config.clientIdentifier)
        .authenticateAs(config.username, config.password)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      state = client.connectionStatus!.state; // Notify UI
      print("Connected to MQTT Broker");
    } catch (e) {
      print("Connection failed: $e");
      client.disconnect();
      state = MqttConnectionState.disconnected; // Notify UI
    }
  }

  void disconnect() {
    client.disconnect();
    state = MqttConnectionState.disconnected; // Notify UI
  }
}
