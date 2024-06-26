import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baja_app/dominio/insumos.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  static final _logger = Logger();

  static Future<List<Insumo>> getInsumosFromDatabase(String inventoryId) async {
    try {
      final insumosCollection = FirebaseFirestore.instance.collection('Inventarios').doc(inventoryId).collection('insumos');
      final querySnapshot = await insumosCollection.get();

      final insumos = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Insumo(
          id: doc.id,
          nombre: data['nombre'] ?? '',
          cantidad: data['cantidad'] ?? 0,
          cantidadMinima: data['cantidadMinima'] ?? 0,
        );
      }).toList();

      return insumos;
    } catch (error) {
      _logger.e('Error al obtener los insumos: $error');
      return [];
    }
  }

  static Future<void> incrementarCantidadInsumo(String inventoryId, String insumoId) async {
    try {
      final insumoRef = FirebaseFirestore.instance.collection('Inventarios').doc(inventoryId).collection('insumos').doc(insumoId);
      await insumoRef.update({'cantidad': FieldValue.increment(1)});
    } catch (error) {
      _logger.e('Error al incrementar la cantidad: $error');
      throw 'Error al incrementar la cantidad: $error';
    }
  }

  static Future<void> decrementarCantidadInsumo(String inventoryId, String insumoId) async {
    try {
      final insumoRef = FirebaseFirestore.instance.collection('Inventarios').doc(inventoryId).collection('insumos').doc(insumoId);
      final snapshot = await insumoRef.get();
      final int currentQuantity = snapshot.data()?['cantidad'] ?? 0;

      if (currentQuantity > 0) {
        await insumoRef.update({'cantidad': FieldValue.increment(-1)});
      } else {
        throw 'La cantidad no puede ser menor a 0';
      }
    } catch (error) {
      _logger.e('Error al decrementar la cantidad: $error');
      throw 'Error al decrementar la cantidad: $error';
    }
  }

  static Future<void> eliminarInsumo(String inventoryId, String insumoId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Inventarios')
          .doc(inventoryId)
          .collection('insumos')
          .doc(insumoId)
          .delete();
    } catch (error) {
      throw 'Error al eliminar el insumo: $error';
    }
  }

  static Future<void> agregarInsumo(String inventoryId, Insumo insumo) async {
    try {
      await FirebaseFirestore.instance
          .collection('Inventarios')
          .doc(inventoryId)
          .collection('insumos')
          .add(insumo.toMap());
    } catch (error) {
      throw 'Error al agregar el insumo: $error';
    }
  }

  static Future<void> actualizarCantidadInsumo(String inventoryId, String insumoId, int nuevaCantidad) async {
    try {
      if (nuevaCantidad < 0) {
        throw 'La cantidad no puede ser menor a 0';
      }

      final insumoRef = FirebaseFirestore.instance.collection('Inventarios').doc(inventoryId).collection('insumos').doc(insumoId);
      await insumoRef.update({'cantidad': nuevaCantidad});
    } catch (error) {
      _logger.e('Error al actualizar la cantidad del insumo: $error');
      throw 'Error al actualizar la cantidad del insumo: $error';
    }
  }
}
