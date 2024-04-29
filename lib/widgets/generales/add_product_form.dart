import 'package:baja_app/dominio/insumos.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:logger/logger.dart';

class AddProductForm extends StatelessWidget {
  final String inventoryId;
  final void Function(String, int, int) onInsumoAdded;
  final Logger _logger = Logger();

  AddProductForm({super.key, required this.inventoryId, required this.onInsumoAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController minQuantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(centerTitle: true,
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
    final int parsedQuantity = int.tryParse(quantity) ?? 0;
    final int parsedMinQuantity = int.tryParse(minQuantity) ?? 0;

    if (productName.isNotEmpty && parsedQuantity > 0 && parsedMinQuantity >= 0) {
      final newInsumo = Insumo(
        id: UniqueKey().toString(),
        nombre: productName,
        cantidad: parsedQuantity,
        cantidadMinima: parsedMinQuantity,
      );

      FirebaseService.agregarInsumo(inventoryId, newInsumo).then((_) {
        // Actualizar la interfaz de usuario después de agregar el insumo
        onInsumoAdded(productName, parsedQuantity, parsedMinQuantity);
        Navigator.pop(context); // Cierra el formulario después de agregar el insumo
      }).catchError((error) {
        // Manejar errores de base de datos, si es necesario
        _logger.e('Error al agregar el insumo: $error');
        // Puedes mostrar un snackbar o un diálogo de error aquí
      });
    } else {
      // Manejar el caso en el que los campos del formulario no son válidos
      // Por ejemplo, mostrar un mensaje de error o validar los campos individualmente
    }
  }
}
