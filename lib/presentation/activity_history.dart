import 'package:flutter/material.dart';
import 'package:baja_app/dominio/pedidos/pedido_history.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<String> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  void _cargarPedidos() async {
    List<dynamic> pedidos = await PedidoHistory.getPedidos();
    List<String> pedidosStrings =
        pedidos.map((pedido) => pedido.toString()).toList();
    setState(() {
      _pedidos = pedidosStrings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Historial de Pedidos',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white, size: 30),
            onPressed: _borrarHistorialPedidos,
          ),
        ],
      ),
      body: _pedidos.isNotEmpty
          ? ListView.builder(
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                String pedido = _pedidos[index];
                return ListTile(
                  title: Text('Pedido ${index + 1}'),
                  subtitle: Text(pedido),
                );
              },
            )
          : Center(
              child: Text('No hay pedidos'),
            ),
    );
  }

  void _borrarHistorialPedidos() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Borrar Historial'),
          content: const Text('¿Quieres borrar todo el historial de pedidos?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _confirmarBorrarHistorialPedidos();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarBorrarHistorialPedidos() async {
    await PedidoHistory.clearPedidos();
    setState(() {
      _pedidos = [];
    });
  }
}
