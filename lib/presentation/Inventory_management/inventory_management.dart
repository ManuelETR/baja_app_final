import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const InventoryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text('Gestión de Inventarios', style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _InventoryView(),
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
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            icon: Icons.precision_manufacturing_outlined,
            text: 'Producción',
            onPressed: () {
              //Navegar a la pantalla de Produccion
              Navigator.pushNamed(context, '/production');
            },
          ),
          CustomButton(
            icon: Icons.design_services,
            text: 'Papelería',
            onPressed: () {
              //Navegar a la pantalla de Papeleria
              Navigator.pushNamed(context, '/stationery');
            },
          ),
          CustomButton(
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

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;

  const CustomButton({
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
