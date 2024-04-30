import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          // Cambiar el color de la flecha hacia atrás
          color: Colors.white, // Cambia este color al que desees
          onPressed: () {
            // Agrega aquí la lógica para volver atrás si es necesario
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text('Notificaciones de Alarmas', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}