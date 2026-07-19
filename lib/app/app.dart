import 'package:flutter/material.dart';
import '../presentation/home/home_page.dart';

class MqttAlertApp extends StatelessWidget {
  const MqttAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ù‡Ø´Ø¯Ø§Ø± MQTT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
