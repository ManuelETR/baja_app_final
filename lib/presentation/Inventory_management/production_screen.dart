import 'package:baja_app/dominio/notifications/snackbar_history.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/dominio/insumos.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:baja_app/presentation/index.dart'; // Importa el formulario para agregar insumos

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({Key? key}) : super(key: key);

  @override
  _ProductionScreenState createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  List<Insumo> _insumos = [];

  @override
  void initState() {
    super.initState();
    _loadInsumos();
  }

  Future<void> _loadInsumos() async {
    List<Insumo> insumos = await FirebaseService.getInsumosFromDatabase('produccion');
    setState(() {
      _insumos = insumos;
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
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Insumos de Producción',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_sharp, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductForm(
                    inventoryId: 'produccion',
                    onInsumoAdded: (String nombre, int cantidad, int cantidadMinima) {
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
          return Container(
            color: insumo.cantidad <= insumo.cantidadMinima ? Colors.pink[100] : null,
            child: ListTile(
              title: Text(insumo.nombre),
              subtitle: Text('Cantidad: ${insumo.cantidad}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF053F93)),
                    onPressed: () => _incrementarCantidad(insumo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_outlined, color: Color(0xFF053F93)),
                    onPressed: () => _decrementarCantidad(insumo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 171, 36, 26)),
                    onPressed: () => _eliminarInsumo(insumo),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _incrementarCantidad(Insumo insumo) async {
    await FirebaseService.incrementarCantidadInsumo('produccion', insumo.id);
    setState(() {
      insumo.cantidad++;
    });
    if (insumo.cantidad <= insumo.cantidadMinima) {
      String message = 'El insumo ${insumo.nombre} del área de Producción llegó a cantidad mínima, debes rellenar el stock.';
      _showSnackBar(message);
      SnackBarHistory.addMessage(message);
    }
  }

  void _decrementarCantidad(Insumo insumo) async {
    await FirebaseService.decrementarCantidadInsumo('produccion', insumo.id);
    setState(() {
      if (insumo.cantidad > 0) {
        insumo.cantidad--;
      }
    });
    if (insumo.cantidad <= insumo.cantidadMinima) {
      String message = 'El insumo ${insumo.nombre} del área de Producción llegó a cantidad mínima, debes rellenar el stock.';
      _showSnackBar(message);
      SnackBarHistory.addMessage(message);
    }
  }

  void _eliminarInsumo(Insumo insumo) async {
    await FirebaseService.eliminarInsumo('produccion', insumo.id);
    setState(() {
      _insumos.removeWhere((element) => element.id == insumo.id);
    });
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
