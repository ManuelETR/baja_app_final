import 'package:shared_preferences/shared_preferences.dart';

class EntradaHistory {
  static const _key = 'entradaHistory';

  static Future<List<String>> getEntradas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? entradas = prefs.getStringList(_key);
    return entradas ?? [];
  }

  static Future<void> addEntrada(String entrada) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> entradas = await getEntradas();
    entradas.add(entrada);
    prefs.setStringList(_key, entradas);
  }

  static Future<void> clearEntradas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
