import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ØªÙ†Ø¸ÛŒÙ…Ø§Øª MQTT'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Ø§ÛŒÙ† ØµÙØ­Ù‡ Ø¯Ø± Ù…Ø±Ø­Ù„Ù‡ Ø¨Ø¹Ø¯ Ú©Ø§Ù…Ù„ Ù…ÛŒ Ø´ÙˆØ¯.'),
        ),
      ),
    );
  }
}
