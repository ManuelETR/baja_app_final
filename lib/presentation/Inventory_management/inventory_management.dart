import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const InventoryScreen({Key? key});

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
        title: const Text('Gestión de Inventarios', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _InventoryView(),
      //AQUI TIENE QUE IR EL BODY
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
      ),
    );
  }
}



class _InventoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ButtonSection();
  }
}

class _ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButtonI(
            icon: Icons.precision_manufacturing_outlined,
            text: 'Producción',
            onPressed: () {
              //Navegar a la pantalla de Produccion
              Navigator.pushNamed(context, '/production');
            },
          ),
          CustomButtonI(
            icon: Icons.design_services,
            text: 'Papelería',
            onPressed: () {
              //Navegar a la pantalla de Papeleria
              Navigator.pushNamed(context, '/stationery');
            },
          ),
          CustomButtonI(
            icon: Icons.cleaning_services_sharp,
            text: 'Limpieza',
            onPressed: () {
              //Navegar a la pantalla de Limpieza
              Navigator.pushNamed(context, '/cleaning');
            },
          ),
        ],
      ),
    );
  }
}

class CustomButtonI extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;

  const CustomButtonI({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 80),
        const VerticalDivider(),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
