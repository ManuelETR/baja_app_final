import 'package:baja_app/dominio/pedidos/pedido_history_entries.dart';
import 'package:flutter/material.dart';

class ActivityScreenEntries extends StatefulWidget {
  const ActivityScreenEntries({Key? key}) : super(key: key);

  @override
  _ActivityScreenEntriesState createState() => _ActivityScreenEntriesState();
}

class _ActivityScreenEntriesState extends State<ActivityScreenEntries> {
  List<String> _entradas = [];

  @override
  void initState() {
    super.initState();
    _cargarEntradas();
  }

  void _cargarEntradas() async {
    List<dynamic> entradas = await EntradaHistory.getEntradas();
    List<String> entradasStrings = entradas.map((entrada) => entrada.toString()).toList();
    setState(() {
      _entradas = entradasStrings;
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
          'Historial de Entradas',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white, size: 30),
            onPressed: _borrarHistorialEntradas,
          ),
        ],
      ),
      body: _entradas.isNotEmpty
          ? Container(
              color: Colors.white, // Fondo blanco para la pantalla
              child: ListView.builder(
                itemCount: _entradas.length,
                itemBuilder: (context, index) {
                  String entrada = _entradas[index];
                  List<String> elementos = entrada.split(','); // Suponiendo que los elementos estén separados por comas

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      color: const Color(0xFFCEF7CE), // Color verde pastel para las notas
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
                              'Entrada ${index + 1}',
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
              ),
            )
          : const Center(
              child: Text('No hay entradas'),
            ),
    );
  }

  void _borrarHistorialEntradas() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Borrar Historial'),
          content: const Text('¿Quieres borrar todo el historial de entradas?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _confirmarBorrarHistorialEntradas();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarBorrarHistorialEntradas() async {
    await EntradaHistory.clearEntradas();
    setState(() {
      _entradas = [];
    });
  }
}
