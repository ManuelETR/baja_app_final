import 'package:flutter/material.dart';
import 'package:baja_app/dominio/pedidos/pedido_history.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

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
    List<String> pedidosStrings = pedidos.map((pedido) => pedido.toString()).toList();
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
                List<String> elementos = pedido.split(','); // Suponiendo que los elementos estén separados por comas

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    color: const Color(0xFFFFF9C4), // Color amarillo pastel para las notas
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Pedido ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(), // Línea separadora
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: elementos.length,
                          itemBuilder: (context, subIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                              child: Text(
                                elementos[subIndex],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
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
