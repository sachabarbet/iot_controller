import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../shared/mqtt/data/esp_mode_enum.dart';
import '../../../shared/mqtt/presentation/mqtt_service_provider.dart';
import '../data/led_control_entity.dart';
import '../data/led_topic_constants.dart';

final ledControlProvider = StateNotifierProvider<LedControlNotifier, LedControl>((ref) {
  return LedControlNotifier(ref);
});

class LedControlNotifier extends StateNotifier<LedControl> {
  final Ref ref;

  LedControlNotifier(this.ref) : super(const LedControl(
    espMode: EspMode.auto, // Default mode
    ledValues: [0, 0, 0],
    luxValue: 0,
    luxTriggerOn: 100,
    luxTriggerOff: 50,
    luxDebounced: false,
  ));

  void getData() {
    final builder = MqttClientPayloadBuilder();

    ref.read(mqttServiceProvider.notifier).client.publishMessage(ledPingTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void updateState(LedControl newState) {
    state = newState;
  }

  void subscribeToLedState() {
    ref.read(mqttServiceProvider.notifier).client.subscribe(ledDataTopic, MqttQos.atLeastOnce);

    ref.read(mqttServiceProvider.notifier).client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMessage = messages![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      _handleLedStateUpdate(payload);
    });
  }

  void _handleLedStateUpdate(String payload) {
    final Map<String, dynamic> data = jsonDecode(payload);

    final ledControl = LedControl(
      espMode: EspMode.values[int.parse(data['espMode'])],
      ledValues: List<int>.from(data['ledValues']),
      luxValue: data['luxValue'] ?? 0,
      luxTriggerOn: data['luxTriggerOn'] ?? 100,
      luxTriggerOff: data['luxTriggerOff'] ?? 50,
      luxDebounced: data['luxDebounced'] ?? false,
    );

    // Update state
    ref.read(ledControlProvider.notifier).updateState(ledControl);
  }

  void requestLedState() {
    final builder = MqttClientPayloadBuilder();
    builder.addString('ping');

    ref.read(mqttServiceProvider.notifier).client.publishMessage(ledPingTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void setLedValues(List<int> values) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(values.join(','));

    ref.read(mqttServiceProvider.notifier).client.publishMessage(ledControlTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void setControlMode(EspMode mode) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(mode.index.toString());

    ref.read(mqttServiceProvider.notifier).client.publishMessage(ledModeTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void unsubscribe() {
    ref.read(mqttServiceProvider.notifier).client.unsubscribe(ledDataTopic);
  }
}