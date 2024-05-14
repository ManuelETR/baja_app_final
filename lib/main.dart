import 'package:baja_app/config/theme/app_theme.dart';
import 'package:baja_app/dominio/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'presentation/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  final _routes = {
    '/sign': (context) => const SignUpPage(),
    '/home': (context) => const HomeScreen(),
    '/profile': (context) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return ProfileScreen(userId: currentUser.uid);
      } else {
        return const LoginPage();
      }
    },
    '/profilesettings': (context) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return ProfileSettingsScreen(user: UserM.fromFirebaseUser(currentUser));
      } else {
        return const LoginPage();
      }
    },
    '/activity': (context) => const ActivityScreen(),
    '/notifications': (context) => const NotificationsScreen(),
    '/inventory': (context) => const InventoryScreen(),
    '/production': (context) => const ProductionScreen(),
    '/stationery': (context) => const StationeryScreen(),
    '/cleaning': (context) => const CleaningScreen(),
    '/add_product': (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final inventoryId = args['inventoryId'] as String;
      return AddProductForm(
        inventoryId: inventoryId,
        onInsumoAdded: onInsumoAdded,
      );
    },
    '/order': (context) => InsumoSelectionScreen(insumos: const [], updateParentScreen: () {}),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BajaApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).theme(),
      initialRoute: '/',
      routes: _routes,
      home: AuthWrapper(),
    );
  }

  static void onInsumoAdded(String id, int cantidad, int cantidadMinima) {
    // Lógica para manejar el nuevo insumo agregado
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
