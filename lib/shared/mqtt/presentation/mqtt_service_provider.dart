import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../core/services/mqtt_service.dart';

final mqttServiceProvider =
StateNotifierProvider<MqttService, MqttConnectionState>((ref) {
  return MqttService();
});
