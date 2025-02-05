import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../entities/mqtt_config_entity.dart';
import '../repositories/mqtt_config_repository.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  late final MqttServerClient client;
  late final MqttConfig config;

  MqttService._internal() {
    _loadConfig();
    _loadClient();
  }

  Future<void> _loadConfig() async {
    config = await MqttRepository().loadMqttConfig();
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

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
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
      print("Connected to MQTT Broker");
    } catch (e) {
      print("Connection failed: $e");
      client.disconnect();
    }
  }

  void onConnected() => print('Connected to MQTT');
  void onDisconnected() => print('Disconnected from MQTT');
  void onSubscribed(String topic) => print('Subscribed to: $topic');

  void subscribe(String topic, Function(String) onMessageReceived) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      onMessageReceived(payload);
    });
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect() {
    client.disconnect();
  }
}
