import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/entities/mqtt_config_entity.dart';
import '../../../core/repositories/mqtt_config_repository.dart';
import 'mqtt_repository_provider.dart';
import 'mqtt_service_provider.dart';

final mqttConfigProvider =
    StateNotifierProvider<MqttConfigNotifier, MqttConfig>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return MqttConfigNotifier(repository, ref);
});

class MqttConfigNotifier extends StateNotifier<MqttConfig> {
  final MqttRepository repository;
  final Ref ref;


  MqttConfigNotifier(this.repository, this.ref)
      : super(repository.loadMqttConfig());

  void connect(BuildContext context) {
    ref.read(mqttServiceProvider.notifier).connect(context);
  }

  bool getConnectionTriggered() {
    return ref.read(mqttServiceProvider.notifier).connectionTriggered;
  }

  Future<void> saveConfig(MqttConfig config) async {
    await repository.saveMqttConfig(config);
    state = config;
    ref.read(mqttServiceProvider.notifier).loadConfig();
    ref.read(mqttServiceProvider.notifier).loadClient();
  }
}
