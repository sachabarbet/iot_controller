import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../shared/mqtt/data/esp_mode_enum.dart';
import '../../../shared/mqtt/presentation/mqtt_service_provider.dart';
import '../data/shutter_control_entity.dart';
import '../data/shutter_topic_constants.dart';

final shutterControlProvider = StateNotifierProvider<ShutterControlNotifier, ShutterControl>((ref) {
  return ShutterControlNotifier(ref);
});

class ShutterControlNotifier extends StateNotifier<ShutterControl> {
  final Ref ref;

  ShutterControlNotifier(this.ref) : super(const ShutterControl(
    espMode: EspMode.auto, // Default mode
    shutterValue: 0,
    luxValue: 0,
    luxTriggerOn: 100,
    luxTriggerOff: 50,
    luxDebounced: false,
  ));

  void updateState(ShutterControl newState) {
    state = newState;
  }

  void subscribeToLedState() {
    ref.read(mqttServiceProvider.notifier).client.subscribe(shutterDataTopic, MqttQos.atLeastOnce);

    ref.read(mqttServiceProvider.notifier).client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMessage = messages![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      _handleLedStateUpdate(payload);

    });
  }

  void _handleLedStateUpdate(String payload) {
    final Map<String, dynamic> data = jsonDecode(payload);

    final ledControl = ShutterControl(
      espMode: EspMode.values[data['espMode']],
      shutterValue: data['ledValues'] ?? 0,
      luxValue: data['luxValue'] ?? 0,
      luxTriggerOn: data['luxTriggerOn'] ?? 100,
      luxTriggerOff: data['luxTriggerOff'] ?? 50,
      luxDebounced: data['luxDebounced'] ?? false,
    );

    // Update state
    ref.read(shutterControlProvider.notifier).updateState(ledControl);
  }

  void requestLedState() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('ping');

    ref.read(mqttServiceProvider.notifier).client.publishMessage(shutterPingTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void setShutterValue(int value) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(value.toString());

    ref.read(mqttServiceProvider.notifier).client.publishMessage(shutterControlTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void setControlMode(EspMode mode) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(mode.index.toString());

    ref.read(mqttServiceProvider.notifier).client.publishMessage(shutterModeTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void unsubscribe() {
    ref.read(mqttServiceProvider.notifier).client.unsubscribe(shutterDataTopic);
  }
}