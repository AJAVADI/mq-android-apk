import 'package:flutter/material.dart';

import '../../domain/models/mqtt_settings.dart';

class SettingsScreen extends StatefulWidget {
  final MqttSettings? initialSettings;

  const SettingsScreen({super.key, this.initialSettings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _brokerController;
  late final TextEditingController _portController;
  late final TextEditingController _clientIdController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialSettings;

    _brokerController = TextEditingController(text: initial?.broker ?? '');
    _portController = TextEditingController(
      text: initial?.port.toString() ?? '1883',
    );
    _clientIdController = TextEditingController(text: initial?.clientId ?? '');
    _usernameController = TextEditingController(text: initial?.username ?? '');
    _passwordController = TextEditingController(text: initial?.password ?? '');
  }

  @override
  void dispose() {
    _brokerController.dispose();
    _portController.dispose();
    _clientIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = MqttSettings(
      broker: _brokerController.text.trim(),
      port: int.parse(_portController.text.trim()),
      clientId: _clientIdController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    Navigator.pop(context, settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات MQTT'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _brokerController,
                  decoration: const InputDecoration(
                    labelText: 'Broker',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'آدرس broker را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _portController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'پورت را وارد کنید';
                    }

                    final port = int.tryParse(value.trim());
                    if (port == null || port <= 0 || port > 65535) {
                      return 'پورت معتبر وارد کنید';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _clientIdController,
                  decoration: const InputDecoration(
                    labelText: 'Client ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Client ID را وارد کنید';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveSettings,
                    child: const Text('ذخیره'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
