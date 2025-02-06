class MqttConfig {
  final String brokerHost;
  final int brokerPort;
  final String clientIdentifier;
  final String username;
  final String password;
  final bool isSecure;
  final String tlsCertificatePath;

  const MqttConfig({
    required this.brokerHost,
    required this.brokerPort,
    required this.clientIdentifier,
    required this.username,
    required this.password,
    required this.isSecure,
    this.tlsCertificatePath = '',
  });

  MqttConfig copyWith({
    String? brokerHost,
    int? brokerPort,
    String? clientIdentifier,
    String? username,
    String? password,
    bool? isSecure,
    String? tlsCertificatePath,
  }) {
    return MqttConfig(
      brokerHost: brokerHost ?? this.brokerHost,
      brokerPort: brokerPort ?? this.brokerPort,
      clientIdentifier: clientIdentifier ?? this.clientIdentifier,
      username: username ?? this.username,
      password: password ?? this.password,
      isSecure: isSecure ?? this.isSecure,
      tlsCertificatePath: tlsCertificatePath ?? this.tlsCertificatePath,
    );
  }
}
