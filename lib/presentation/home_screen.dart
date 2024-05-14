import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _documentCreationFuture;

  @override
  void initState() {
    super.initState();
    _documentCreationFuture = _createUserDocument();
  }

  Future<void> _createUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // El documento del usuario no existe, crearlo
      await userDoc.set({
        'email': user.email,
        'name': '',
        'lastName': '',
        'bio': '',
        'phone': '',
        'address': '',
        'website': '',
        'imageUrl': '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: FutureBuilder(
        future: _documentCreationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se espera la creación del documento
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Maneja errores si ocurre alguno durante la creación del documento
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // El documento ha sido creado exitosamente, muestra el contenido del HomeScreen
            return _HomeView();
          }
        },
      ),
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
              fontFamily: 'Syne', // Usar la fuente Syne
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold, // Puedes ajustar el peso de la fuente según tus preferencias
            ),
          ),
          VerticalDivider(),
          Icon(Icons.table_chart_rounded, color: Colors.white, size: 35),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
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
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          CustomButton(
            icon: Icons.inventory_outlined,
            text: 'Gestión',
            onPressed: () {
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
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
  }) : super(key: key);

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
