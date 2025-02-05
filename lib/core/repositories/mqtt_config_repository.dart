import 'package:iot_controller/core/services/shared_preferences_service.dart';

import '../entities/mqtt_config_entity.dart';

class MqttRepository {
  static const String _keyBrokerHost = "mqtt_broker_host";
  static const String _keyBrokerPort = "mqtt_broker_port";
  static const String _keyClientId = "mqtt_client_id";
  static const String _keyUsername = "mqtt_username";
  static const String _keyPassword = "mqtt_password";
  static const String _keyIsSecure = "mqtt_is_secure";
  static const String _keyTlsCertificatePath = "mqtt_tls_certificate_path";

  Future<void> saveMqttConfig(MqttConfig config) async {
    final prefs = SharedPreferencesService().prefs;
    await prefs.setString(_keyBrokerHost, config.brokerHost);
    await prefs.setInt(_keyBrokerPort, config.brokerPort);
    await prefs.setString(_keyClientId, config.clientIdentifier);
    await prefs.setString(_keyUsername, config.username);
    await prefs.setString(_keyPassword, config.password);
    await prefs.setBool(_keyIsSecure, config.isSecure);
    await prefs.setString(_keyTlsCertificatePath, config.tlsCertificatePath);
  }

  Future<MqttConfig> loadMqttConfig() async {
    final prefs = SharedPreferencesService().prefs;
    return MqttConfig(
      brokerHost: prefs.getString(_keyBrokerHost) ?? 'default_host',
      brokerPort: prefs.getInt(_keyBrokerPort) ?? 1883,
      clientIdentifier: prefs.getString(_keyClientId) ?? 'flutter_client',
      username: prefs.getString(_keyUsername) ?? 'user',
      password: prefs.getString(_keyPassword) ?? 'password',
      isSecure: prefs.getBool(_keyIsSecure) ?? false,
      tlsCertificatePath: prefs.getString(_keyTlsCertificatePath) ?? '',
    );
  }
}
