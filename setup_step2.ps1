$ErrorActionPreference = "Stop"

Write-Host "Creating folders..." -ForegroundColor Cyan

$folders = @(
    "lib/app",
    "lib/core/constants",
    "lib/core/errors",
    "lib/core/utils",
    "lib/domain/entities",
    "lib/domain/repositories",
    "lib/domain/usecases",
    "lib/data/models",
    "lib/data/datasources/local",
    "lib/data/datasources/mqtt",
    "lib/data/repositories",
    "lib/application/services",
    "lib/presentation/home",
    "lib/presentation/settings",
    "lib/presentation/widgets",
    "lib/platform/android"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
}

Write-Host "Writing pubspec.yaml..." -ForegroundColor Cyan

@'
name: mqtt_alert_v2
description: MQTT Alert application built with Flutter.
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  mqtt_client: ^10.5.1
  shared_preferences: ^2.3.2
  flutter_local_notifications: ^17.2.3
  vibration: ^2.0.1
  audioplayers: ^6.1.0
  intl: ^0.19.0
  path_provider: ^2.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
'@ | Set-Content -Path "pubspec.yaml" -Encoding UTF8

Write-Host "Writing lib/main.dart..." -ForegroundColor Cyan

@'
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MqttAlertApp());
}
'@ | Set-Content -Path "lib/main.dart" -Encoding UTF8

Write-Host "Writing lib/app/app.dart..." -ForegroundColor Cyan

@'
import 'package:flutter/material.dart';
import '../presentation/home/home_page.dart';

class MqttAlertApp extends StatelessWidget {
  const MqttAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'هشدار MQTT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
'@ | Set-Content -Path "lib/app/app.dart" -Encoding UTF8

Write-Host "Writing lib/presentation/home/home_page.dart..." -ForegroundColor Cyan

@'
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          children: const [
            _StatusCard(
              title: 'وضعیت اتصال',
              value: 'قطع',
              color: Colors.red,
              icon: Icons.wifi_off,
            ),
            SizedBox(height: 12),
            _StatusCard(
              title: 'آخرین پیام',
              value: 'هنوز پیامی دریافت نشده است',
              color: Colors.blue,
              icon: Icons.message_outlined,
            ),
            SizedBox(height: 12),
            _StatusCard(
              title: 'آخرین هشدار',
              value: 'هشداری ثبت نشده است',
              color: Colors.orange,
              icon: Icons.notifications_active_outlined,
            ),
            SizedBox(height: 12),
            _StatusCard(
              title: 'تعداد پیام‌ها',
              value: '0',
              color: Colors.teal,
              icon: Icons.countertops_outlined,
            ),
            SizedBox(height: 12),
            _StatusCard(
              title: 'وضعیت سرویس',
              value: 'غیرفعال',
              color: Colors.grey,
              icon: Icons.settings_applications_outlined,
            ),
            SizedBox(height: 12),
            _StatusCard(
              title: 'وضعیت هشدار فعال',
              value: 'هیچ هشداری فعال نیست',
              color: Colors.purple,
              icon: Icons.alarm_off_outlined,
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
                  Text(
                    value,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Path "lib/presentation/home/home_page.dart" -Encoding UTF8

Write-Host "Writing lib/presentation/settings/settings_page.dart..." -ForegroundColor Cyan

@'
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تنظیمات MQTT'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('این صفحه در مرحله بعد کامل می شود.'),
        ),
      ),
    );
  }
}
'@ | Set-Content -Path "lib/presentation/settings/settings_page.dart" -Encoding UTF8

Write-Host "Running flutter pub get with mirror..." -ForegroundColor Cyan

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

flutter pub get

Write-Host "Done." -ForegroundColor Green
Write-Host "Next: flutter run -d chrome" -ForegroundColor Yellow
