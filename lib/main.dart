import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/services/mqtt_service.dart';
import 'domain/models/mqtt_settings.dart';
import 'presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MqttAlertApp());
}

class MqttAlertApp extends StatelessWidget {
  const MqttAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Alert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _brokerKey = 'mqtt_broker';
  static const String _portKey = 'mqtt_port';
  static const String _clientIdKey = 'mqtt_client_id';
  static const String _usernameKey = 'mqtt_username';
  static const String _passwordKey = 'mqtt_password';

  final MqttService _mqttService = MqttService();

  MqttSettings? _currentSettings;
  bool _isLoading = true;
  bool _isOpeningSettings = false;
  bool _isTestingConnection = false;
  String _connectionStatus = 'قطع';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final broker = prefs.getString(_brokerKey) ?? '';
    final port = prefs.getInt(_portKey) ?? 1883;
    final clientId = prefs.getString(_clientIdKey) ?? '';
    final username = prefs.getString(_usernameKey) ?? '';
    final password = prefs.getString(_passwordKey) ?? '';

    MqttSettings? loadedSettings;
    if (broker.trim().isNotEmpty) {
      loadedSettings = MqttSettings(
        broker: broker,
        port: port,
        clientId: clientId,
        username: username,
        password: password,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentSettings = loadedSettings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings(MqttSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_brokerKey, settings.broker);
    await prefs.setInt(_portKey, settings.port);
    await prefs.setString(_clientIdKey, settings.clientId);
    await prefs.setString(_usernameKey, settings.username);
    await prefs.setString(_passwordKey, settings.password);
  }

  Future<void> _openSettings() async {
    if (_isOpeningSettings) {
      return;
    }

    setState(() {
      _isOpeningSettings = true;
    });

    final result = await Navigator.push<MqttSettings>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(initialSettings: _currentSettings),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        _isOpeningSettings = false;
      });
      return;
    }

    try {
      await _saveSettings(result);

      if (!mounted) {
        return;
      }

      setState(() {
        _currentSettings = result;
        _isOpeningSettings = false;
        _connectionStatus = 'قطع';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تنظیمات با موفقیت ذخیره شد')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOpeningSettings = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ذخیره تنظیمات با خطا مواجه شد')),
      );
    }
  }

  Future<void> _testConnection() async {
    final settings = _currentSettings;

    if (settings == null || settings.broker.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ابتدا تنظیمات MQTT را ذخیره کنید')),
      );
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _connectionStatus = 'در حال بررسی...';
    });

    try {
      _mqttService.createClient(
        server: settings.broker,
        port: settings.port,
        clientId: settings.clientId,
        username: settings.username,
        password: settings.password,
      );

      final isConnected = await _mqttService.connect();

      if (!mounted) {
        return;
      }

      setState(() {
        _isTestingConnection = false;
        _connectionStatus = isConnected ? 'متصل' : 'قطع';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConnected
                ? 'اتصال به بروکر با موفقیت انجام شد'
                : 'اتصال به بروکر انجام نشد',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isTestingConnection = false;
        _connectionStatus = 'خطا';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('در تست اتصال خطا رخ داد')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = _currentSettings;
    final hasSettings = settings != null && settings.broker.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('MQTT Alert'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: hasSettings
                        ? Colors.green.withOpacity(0.12)
                        : Colors.orange.withOpacity(0.12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                hasSettings
                                    ? Icons.check_circle_outline
                                    : Icons.warning_amber_rounded,
                                color: hasSettings
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  hasSettings
                                      ? 'تنظیمات MQTT ذخیره شده است'
                                      : 'تنظیمات MQTT انجام نشده است',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('وضعیت اتصال: $_connectionStatus'),
                          if (hasSettings && settings != null) ...[
                            const SizedBox(height: 12),
                            Text('Broker: ${settings.broker}'),
                            Text('Port: ${settings.port}'),
                            if (settings.clientId.trim().isNotEmpty)
                              Text('Client ID: ${settings.clientId}'),
                            if (settings.username.trim().isNotEmpty)
                              Text('Username: ${settings.username}'),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isOpeningSettings ? null : _openSettings,
                    icon: _isOpeningSettings
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.settings),
                    label: Text(
                      _isOpeningSettings ? 'در حال باز کردن...' : 'تنظیمات',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _isTestingConnection ? null : _testConnection,
                    icon: _isTestingConnection
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.wifi_tethering),
                    label: Text(
                      _isTestingConnection
                          ? 'در حال تست اتصال...'
                          : 'تست اتصال MQTT',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
