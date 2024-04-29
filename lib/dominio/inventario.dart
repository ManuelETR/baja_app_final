import 'insumos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class Inventario {
  final List<Insumo> insumos = []; // Lista de insumos en el inventario
  final Logger _logger = Logger(); // Instancia del logger

  // Método para agregar un nuevo insumo al inventario
  void agregarInsumo({
    required String id, // Asegúrate de incluir el id como parámetro requerido
    required String nombre,
    required int cantidad,
    required int cantidadMinima,
  }) {
    // Crear una nueva instancia de Insumo con el id proporcionado
    Insumo nuevoInsumo = Insumo(
      nombre: nombre,
      cantidad: cantidad,
      cantidadMinima: cantidadMinima, id: '',
    );

    // Agregar el nuevo insumo a la lista de insumos del inventario
    insumos.add(nuevoInsumo);
  }

  // Método para cargar los insumos desde la base de datos
  Future<void> cargarInsumosDesdeDB(String inventoryId) async {
    try {
      // Obtener el documento de inventario de la base de datos
      DocumentSnapshot<Map<String, dynamic>> inventoryData =
          await FirebaseFirestore.instance
              .collection('Inventarios')
              .doc(inventoryId)
              .get();

      // Verificar si el documento existe y si contiene los datos de insumos
      if (inventoryData.exists && inventoryData.data()!.containsKey('insumos')) {
        // Obtener los datos de insumos del documento de inventario
        List<dynamic>? insumosData = inventoryData.data()!['insumos'];

        // Mapear los datos de insumos a una lista de objetos Insumo
        insumosData?.forEach((insumoData) {
          agregarInsumo(
            id: insumoData['id'] ?? '',
            nombre: insumoData['nombre'] ?? '',
            cantidad: insumoData['cantidad'] ?? 0,
            cantidadMinima: insumoData['cantidadMinima'] ?? 0,
          );
        });
      }
    } catch (error, stackTrace) {
      // Usar el logger para registrar el error y la traza de la pila
      _logger.e('Error al cargar los insumos desde la base de datos', error: error, stackTrace: stackTrace);
    }
  }

  // Método para convertir los datos del inventario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'insumos': insumos.map((insumo) => insumo.toMap()).toList(),
    };
  }
}
