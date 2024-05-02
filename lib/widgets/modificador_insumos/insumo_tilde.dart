import 'package:baja_app/widgets/modificador_insumos/insumo_funtions.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/dominio/insumos.dart';

class InsumoTile extends StatelessWidget {
  final String inventoryId;
  final Insumo insumo;

  const InsumoTile({
    super.key,
    required this.inventoryId,
    required this.insumo, required void Function(Insumo insumo) onIncrementar, required void Function(Insumo insumo) onDecrementar, required void Function(Insumo insumo) onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(insumo.nombre),
      subtitle: Text('Cantidad: ${insumo.cantidad}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _incrementarCantidad(context, insumo),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline_outlined),
            onPressed: () => _decrementarCantidad(context, insumo),
          ),
        ],
      ),
    );
  }

  void _incrementarCantidad(BuildContext context, Insumo insumo) async {
    // Incrementar la cantidad localmente
    insumo.cantidad++;

    // Actualizar la cantidad en la base de datos
    try {
      await InsumoFunctions.actualizarCantidadInsumo(context, inventoryId, insumo);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cantidad: $error'),
        ),
      );
    }
  }

  void _decrementarCantidad(BuildContext context, Insumo insumo) async {
    // Verificar si la cantidad es mayor que cero antes de decrementar
    if (insumo.cantidad > 0) {
      // Decrementar la cantidad localmente
      insumo.cantidad--;

      // Actualizar la cantidad en la base de datos
      try {
        await InsumoFunctions.actualizarCantidadInsumo(context, inventoryId, insumo);
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la cantidad: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La cantidad ya es cero'),
        ),
      );
    }
  }
}
