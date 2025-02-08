import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/repositories/mqtt_config_repository.dart';

final mqttRepositoryProvider = Provider((ref) => MqttRepository());
