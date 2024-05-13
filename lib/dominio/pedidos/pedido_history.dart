import 'package:shared_preferences/shared_preferences.dart';

class PedidoHistory {
  static const _key = 'pedidoHistory';

  static Future<List<String>> getPedidos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? pedidos = prefs.getStringList(_key);
    return pedidos ?? [];
  }

  static Future<void> addPedido(String pedido) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> pedidos = await getPedidos();
    pedidos.add(pedido);
    prefs.setStringList(_key, pedidos);
  }

  static Future<void> clearPedidos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

}
