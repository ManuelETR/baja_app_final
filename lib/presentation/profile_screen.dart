import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('Profile', style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      //AQUI TIENE QUE IR EL BODY
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      ),
    );
  }
}