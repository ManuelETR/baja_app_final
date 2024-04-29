
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: _HomeView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
        },
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF053F93),
      title: const Row(
        children: [
          Text(
            'Baja App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          VerticalDivider(),
          Icon(Icons.all_inbox_sharp, color: Colors.white, size: 30),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ButtonSection();
  }
}

class _ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            icon: Icons.description,
            text: 'Resumen',
            onPressed: () {
              Navigator.pushNamed(context, '/activity');
            },
          ),
          CustomButton(
            icon: Icons.notifications,
            text: 'Avisos',
            onPressed: () {
              // Navegar a la pantalla de Avisos
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          CustomButton(
            icon: Icons.inventory_outlined,
            text: 'Gestión',
            onPressed: () {
              // Navegar a la pantalla de Gestión
              Navigator.pushNamed(context, '/inventory');
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
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
