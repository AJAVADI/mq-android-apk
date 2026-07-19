import 'dart:convert';

class MqttSettings {
  final String broker;
  final int port;
  final String clientId;
  final String username;
  final String password;

  const MqttSettings({
    required this.broker,
    required this.port,
    required this.clientId,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'broker': broker,
      'port': port,
      'clientId': clientId,
      'username': username,
      'password': password,
    };
  }

  factory MqttSettings.fromMap(Map<String, dynamic> map) {
    return MqttSettings(
      broker: map['broker']?.toString() ?? '',
      port: _parsePort(map['port']),
      clientId: map['clientId']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory MqttSettings.fromJson(String source) {
    final decoded = jsonDecode(source);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid MQTT settings format');
    }

    return MqttSettings.fromMap(decoded);
  }

  static int _parsePort(dynamic value) {
    if (value is int && value > 0) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 1883;
  }

  bool get isConfigured {
    return broker.trim().isNotEmpty && port > 0;
  }
}
