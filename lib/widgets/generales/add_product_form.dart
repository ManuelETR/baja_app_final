import 'package:baja_app/dominio/insumos.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:logger/logger.dart';

class AddProductForm extends StatelessWidget {
  final String inventoryId;
  final void Function(String, int, int) onInsumoAdded;
  final Logger _logger = Logger();

  AddProductForm({Key? key, required this.inventoryId, required this.onInsumoAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController minQuantityController = TextEditingController();

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
          'Agregar Insumo',
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: 'Nombre del Insumo'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: minQuantityController,
              decoration: const InputDecoration(labelText: 'Cantidad Mínima'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitForm(context, productNameController.text, quantityController.text, minQuantityController.text);
              },
              child: const Text('Agregar Insumo'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, String productName, String quantity, String minQuantity) {
    if (productName.isEmpty || quantity.isEmpty || minQuantity.isEmpty) {
      _mostrarAviso(context, 'Por favor rellena todos los campos');
      return;
    }

    final int parsedQuantity = int.tryParse(quantity) ?? 0;
    final int parsedMinQuantity = int.tryParse(minQuantity) ?? 0;

    if (parsedQuantity < 0 || parsedMinQuantity < 0) {
      _mostrarAviso(context, 'La cantidad y la cantidad mínima deben ser valores positivos');
      return;
    }

    _mostrarConfirmacion(context, productName, parsedQuantity, parsedMinQuantity);
  }

  void _mostrarAviso(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarConfirmacion(BuildContext context, String productName, int quantity, int minQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Insumo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: $productName'),
              Text('Cantidad: $quantity'),
              Text('Cantidad Mínima: $minQuantity'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarInsumo(context, productName, quantity, minQuantity);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _agregarInsumo(BuildContext context, String productName, int quantity, int minQuantity) {
    final newInsumo = Insumo(
      id: UniqueKey().toString(),
      nombre: productName,
      cantidad: quantity,
      cantidadMinima: minQuantity,
    );

    FirebaseService.agregarInsumo(inventoryId, newInsumo).then((_) {
      // Actualizar la interfaz de usuario después de agregar el insumo
      onInsumoAdded(productName, quantity, minQuantity);
      Navigator.pop(context); // Cierra el diálogo de confirmación
      Navigator.pop(context); // Cierra la pantalla de agregar insumo y regresa a la pantalla anterior
    }).catchError((error) {
      // Manejar errores de base de datos, si es necesario
      _logger.e('Error al agregar el insumo: $error');
      // Puedes mostrar un snackbar o un diálogo de error aquí
    });
  }
}
