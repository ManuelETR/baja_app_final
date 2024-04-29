// ignore_for_file: use_build_context_synchronously

import 'package:baja_app/widgets/modificador_insumos/insumo_service.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/dominio/insumos.dart';

class InsumoFunctions {
  static Future<void> actualizarCantidadInsumo(BuildContext context, String inventoryId, Insumo insumo) async {
  try {
    // Acceder al documento de inventario y al documento de insumo correspondiente
    await InsumoService.actualizarCantidadInsumo(insumo);

    // Mostrar un mensaje de éxito después de que el frame actual se haya completado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cantidad actualizada correctamente'),
        ),
      );
    });
  } catch (error) {
    // Manejar cualquier error que ocurra durante la actualización
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cantidad: $error'),
        ),
      );
    });
  }
}

  static void incrementarCantidad(BuildContext context, String inventoryId, Insumo insumo) async {
    insumo.cantidad++;
    try {
      // Llamar a la función para actualizar la cantidad del insumo
      await actualizarCantidadInsumo(context, inventoryId, insumo);
    } catch (error) {
      // Manejar cualquier error que ocurra durante la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cantidad: $error'),
        ),
      );
    }
  }

  static void decrementarCantidad(BuildContext context, String inventoryId, Insumo insumo) async {
    // Verificar si la cantidad es mayor que cero antes de decrementar
    if (insumo.cantidad > 0) {
      insumo.cantidad--;
      try {
        // Llamar a la función para actualizar la cantidad del insumo
        await actualizarCantidadInsumo(context, inventoryId, insumo);
      } catch (error) {
        // Manejar cualquier error que ocurra durante la actualización
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la cantidad: $error'),
          ),
        );
      }
    } else {
      // Mostrar un mensaje indicando que la cantidad ya es cero
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La cantidad ya es cero'),
        ),
      );
    }
  }
}
