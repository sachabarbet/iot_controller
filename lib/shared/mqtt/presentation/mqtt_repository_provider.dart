import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../core/entities/mqtt_config_entity.dart';
import '../../../core/repositories/mqtt_config_repository.dart';
import '../../../core/services/mqtt_service.dart';

final mqttRepositoryProvider = Provider((ref) => MqttRepository());
