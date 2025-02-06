import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../core/entities/mqtt_config_entity.dart';
import '../../../core/repositories/mqtt_config_repository.dart';
import '../../../core/services/mqtt_service.dart';

final mqttServiceProvider =
StateNotifierProvider<MqttService, MqttConnectionState>((ref) {
  return MqttService();
});

final mqttRepositoryProvider = Provider((ref) => MqttRepository());

final mqttConfigProvider =
    StateNotifierProvider<MqttConfigNotifier, MqttConfig>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return MqttConfigNotifier(repository);
});

class MqttConfigNotifier extends StateNotifier<MqttConfig> {
  final MqttRepository repository;
  late final MqttService service;

  MqttConfigNotifier(this.repository)
      : super(const MqttConfig(
          brokerHost: '',
          brokerPort: 1883,
          clientIdentifier: '',
          username: '',
          password: '',
          isSecure: false,
        )) {
    _loadConfig();
    service = MqttService();
  }

  void _loadConfig() {
    state = repository.loadMqttConfig();
  }

  void connect() {
    service.connect();
  }

  Future<void> saveConfig(MqttConfig config) async {
    await repository.saveMqttConfig(config);
    state = config;
  }
}
