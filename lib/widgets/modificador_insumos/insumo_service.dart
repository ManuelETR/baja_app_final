import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baja_app/dominio/insumos.dart';

class InsumoService {
  static Future<void> actualizarCantidadInsumo(Insumo insumo) async {
    try {
      DocumentReference insumoRef = FirebaseFirestore.instance
          .collection('Inventarios')
          .doc('papeleria')
          .collection('insumos')
          .doc(insumo.id);

      await insumoRef.update({
        'cantidad': insumo.cantidad,
      });
    } catch (error) {
      throw 'Error al actualizar la cantidad: $error';
    }
  }
}
