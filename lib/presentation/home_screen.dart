import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Cerrar sesión'),
                content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Cerrar el diálogo
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Cerrar el diálogo y confirmar la acción
                    },
                    child: const Text('Sí'),
                  ),
                ],
              );
            },
          ).then((value) async {
            if (value != null && value) {
              // Cerrar sesión con Firebase Auth
              await FirebaseAuth.instance.signOut();
              // Cerrar sesión con Google si el usuario inició sesión con Google
              final GoogleSignIn googleSignIn = GoogleSignIn();
              if (await googleSignIn.isSignedIn()) {
                await googleSignIn.signOut();
              }
              // Redirigir a la pantalla de inicio de sesión
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/');
            }
          });
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
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
