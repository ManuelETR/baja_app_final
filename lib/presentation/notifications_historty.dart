import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text('Notificaciones de Alarmas', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}