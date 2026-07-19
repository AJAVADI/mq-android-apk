import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;

  MqttServerClient? get client => _client;

  void createClient({
    required String server,
    required int port,
    required String clientId,
    String? username,
    String? password,
  }) {
    final client = MqttServerClient(server, clientId);

    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.secure = false;

    if (username != null && username.isNotEmpty) {
      client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .authenticateAs(username, password ?? '')
          .startClean()
          .withWillQos(MqttQos.atMostOnce);
    } else {
      client.connectionMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillQos(MqttQos.atMostOnce);
    }

    _client = client;
  }

  Future<bool> connect() async {
    if (_client == null) {
      print('MQTT client is not created');
      return false;
    }

    try {
      await _client!.connect();
      return _client!.connectionStatus?.state == MqttConnectionState.connected;
    } catch (e) {
      print('MQTT connection error: $e');
      _client!.disconnect();
      return false;
    }
  }

  void _onConnected() {
    print('MQTT connected');
  }

  void _onDisconnected() {
    print('MQTT disconnected');
  }

  void _onSubscribed(String topic) {
    print('MQTT subscribed to $topic');
  }
}
