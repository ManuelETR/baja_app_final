// Importaciones necesarias en main
import 'package:baja_app/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

// Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens importations
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
    '/': (context) => const HomeScreen(),
    '/profile': (context) => const ProfileScreen(),
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
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BajaApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).theme(),
      initialRoute: '/',
      routes: _routes,
    );
  }

  static void onInsumoAdded(String id, int cantidad, int cantidadMinima) {
  // Lógica para manejar el nuevo insumo agregado
}
}
