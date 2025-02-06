import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../entities/mqtt_config_entity.dart';
import '../repositories/mqtt_config_repository.dart';
import 'snackbar_service.dart';

class MqttService extends StateNotifier<MqttConnectionState> {
  late MqttServerClient client;
  late MqttConfig config;
  bool connectionTriggered = false;

  MqttService() : super(MqttConnectionState.disconnected) {
    loadConfig();
    loadClient();
  }

  void loadConfig() {
    config = MqttRepository().loadMqttConfig();
  }

  void loadClient() {
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

  Future<void> connect(BuildContext? context) async {
    connectionTriggered = true;
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      if (context != null && context.mounted) {
        SnackBarService.triggerInformationSnackBar(
          context,
          "Already connected to this broker",
        );
      }
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
      if (context != null && context.mounted) {
        SnackBarService.triggerSuccessSnackBar(
          context,
          "Connected to MQTT broker",
        );
      }
    } catch (e) {
      if (context != null && context.mounted) {
        SnackBarService.triggerErrorSnackBar(
          context,
          "Connection failed: $e",
        );
      }
      client.disconnect();
      state = MqttConnectionState.disconnected; // Notify UI
    }
  }

  void updateConnectionState() {
    state = client.connectionStatus != null ? client.connectionStatus!.state : MqttConnectionState.disconnected;
  }

  void disconnect() {
    client.disconnect();
    state = MqttConnectionState.disconnected; // Notify UI
  }
}
