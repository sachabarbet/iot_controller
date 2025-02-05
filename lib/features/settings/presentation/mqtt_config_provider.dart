import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/entities/mqtt_config_entity.dart';
import '../../../core/repositories/mqtt_config_repository.dart';


final mqttRepositoryProvider = Provider((ref) => MqttRepository());

final mqttConfigProvider = StateNotifierProvider<MqttConfigNotifier, MqttConfig>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return MqttConfigNotifier(repository);
});

class MqttConfigNotifier extends StateNotifier<MqttConfig> {
  final MqttRepository repository;

  MqttConfigNotifier(this.repository) : super(const MqttConfig(brokerHost: '', brokerPort: 1883, clientIdentifier: '', username: '', password: '', isSecure: false)) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    state = await repository.loadMqttConfig();
  }

  Future<void> saveConfig(MqttConfig config) async {
    await repository.saveMqttConfig(config);
    state = config;
  }
}
