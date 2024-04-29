import 'package:flutter/material.dart';
import 'package:baja_app/presentation/index.dart'; // Importa el formulario para agregar insumos
import 'package:baja_app/dominio/insumos.dart';
import 'package:baja_app/services/firebase_service.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({Key? key}) : super(key: key);

  @override
  _CleaningScreenState createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  List<Insumo> _insumos = [];

  @override
  void initState() {
    super.initState();
    _loadInsumos();
  }

  Future<void> _loadInsumos() async {
    List<Insumo> insumos = await FirebaseService.getInsumosFromDatabase('limpieza');
    setState(() {
      _insumos = insumos;
    });
  }

  void _incrementarCantidad(Insumo insumo) async {
    await FirebaseService.incrementarCantidadInsumo('limpieza', insumo.id);
    // Actualizar el estado local después de la operación de incremento
    setState(() {
      insumo.cantidad++;
    });
  }

  void _decrementarCantidad(Insumo insumo) async {
    await FirebaseService.decrementarCantidadInsumo('limpieza', insumo.id);
    // Actualizar el estado local después de la operación de decremento
    setState(() {
      if (insumo.cantidad > 0) {
        insumo.cantidad--;
      }
    });
  }

  void _eliminarInsumo(Insumo insumo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Insumo'),
          content: Text('¿Estás seguro de que deseas eliminar ${insumo.nombre}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _eliminarInsumoConfirmed(insumo); // Llamar al método de eliminación confirmado
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarInsumoConfirmed(Insumo insumo) async {
    await FirebaseService.eliminarInsumo('limpieza', insumo.id);
    // Actualizar el estado local después de la eliminación del insumo
    setState(() {
      _insumos.removeWhere((element) => element.id == insumo.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Insumos de Limpieza',
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductForm(
                    inventoryId: 'limpieza', // Asigna el ID de limpieza
                    onInsumoAdded: (String nombre, int cantidad, int cantidadMinima) {
                      // Actualizar la lista de insumos después de agregar uno nuevo
                      _loadInsumos();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _insumos.length,
        itemBuilder: (context, index) {
          Insumo insumo = _insumos[index];
          return ListTile(
            title: Text(insumo.nombre),
            subtitle: Text(
              'Cantidad: ${insumo.cantidad}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _incrementarCantidad(insumo),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _decrementarCantidad(insumo),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _eliminarInsumo(insumo),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}