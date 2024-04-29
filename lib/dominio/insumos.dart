class Insumo {
  final String id;
  final String nombre;
  int cantidad; // Quita la palabra clave 'final' aquí
  final int cantidadMinima;

  Insumo({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.cantidadMinima,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
      'cantidadMinima': cantidadMinima,
    };
  }
}
