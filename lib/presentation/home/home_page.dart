import 'package:flutter/material.dart';
import 'package:mqtt_alert_v2/data/services/mqtt_service.dart';
import 'package:mqtt_alert_v2/data/services/settings_storage.dart';
import 'package:mqtt_alert_v2/domain/models/mqtt_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MqttService _mqttService = MqttService();

  String _connectionStatus = 'قطع';

  Future<void> _testConnection() async {
    final MqttSettings? settings = await SettingsStorage.load();

    if (!mounted) {
      return;
    }

    if (settings == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ابتدا تنظیمات MQTT را ذخیره کنید')),
      );
      return;
    }

    _mqttService.createClient(
      server: settings.server,
      port: settings.port,
      clientId: settings.clientId,
      username: settings.username,
      password: settings.password,
    );

    final bool isConnected = await _mqttService.connect();

    if (!mounted) {
      return;
    }

    setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('هشدار MQTT'),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StatusCard(
              title: 'وضعیت اتصال',
              value: _connectionStatus,
              color: _connectionStatus == 'متصل' ? Colors.green : Colors.red,
              icon: _connectionStatus == 'متصل' ? Icons.wifi : Icons.wifi_off,
            ),
            const SizedBox(height: 12),
            const _StatusCard(
              title: 'آخرین پیام',
              value: 'هنوز پیامی دریافت نشده است',
              color: Colors.blue,
              icon: Icons.message_outlined,
            ),
            const SizedBox(height: 12),
            const _StatusCard(
              title: 'آخرین هشدار',
              value: 'هشداری ثبت نشده است',
              color: Colors.orange,
              icon: Icons.notifications_active_outlined,
            ),
            const SizedBox(height: 12),
            const _StatusCard(
              title: 'تعداد پیام‌ها',
              value: '0',
              color: Colors.teal,
              icon: Icons.countertops_outlined,
            ),
            const SizedBox(height: 12),
            const _StatusCard(
              title: 'وضعیت سرویس',
              value: 'غیرفعال',
              color: Colors.grey,
              icon: Icons.settings_applications_outlined,
            ),
            const SizedBox(height: 12),
            const _StatusCard(
              title: 'وضعیت هشدار فعال',
              value: 'هیچ هشداری فعال نیست',
              color: Colors.purple,
              icon: Icons.alarm_off_outlined,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _testConnection,
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('تست اتصال MQTT'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.settings),
          label: const Text('تنظیمات'),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(value, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
