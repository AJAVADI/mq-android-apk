import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/mqtt_settings.dart';

class SettingsStorage {
  static const String _settingsKey = 'mqtt_settings';

  Future<void> save(MqttSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_settingsKey, settings.toJson());

    if (!saved) {
      throw Exception('Failed to save MQTT settings');
    }
  }

  Future<MqttSettings?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(_settingsKey);

    if (storedValue == null || storedValue.trim().isEmpty) {
      return null;
    }

    try {
      return MqttSettings.fromJson(storedValue);
    } on FormatException {
      await preferences.remove(_settingsKey);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_settingsKey);
  }
}
