import 'package:baja_app/presentation/index.dart';
import 'package:baja_app/widgets/pedido/order_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baja_app/dominio/insumos.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:baja_app/dominio/notifications/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CleaningScreenState createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  List<Insumo> _insumos = [];
  Set<String> _notifiedInsumoIds = <String>{}; // Conjunto para almacenar los IDs de los insumos notificados
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadInsumos('limpieza');
  }

  Future<void> _loadInsumos(String inventoryId) async {
    List<Insumo> insumos = await FirebaseService.getInsumosFromDatabase(inventoryId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String>? notifiedInsumoIds = prefs.getStringList('notifiedInsumoIds')?.toSet() ?? {};

    setState(() {
      _insumos = insumos;
      _notifiedInsumoIds = notifiedInsumoIds;
    });

    // Verificar la cantidad mínima para cada insumo cargado
    for (var insumo in _insumos) {
      _verificarCantidadMinima(insumo);
    }
  }

  void _incrementarCantidad(Insumo insumo) async {
    await FirebaseService.incrementarCantidadInsumo('limpieza', insumo.id);
    setState(() {
      insumo.cantidad++;
    });
    _verificarCantidadMinima(insumo);
  }

  void _decrementarCantidad(Insumo insumo) async {
    await FirebaseService.decrementarCantidadInsumo('limpieza', insumo.id);
    setState(() {
      if (insumo.cantidad > 0) {
        insumo.cantidad--;
      }
    });
    _verificarCantidadMinima(insumo);
  }

  void _verificarCantidadMinima(Insumo insumo) async {
    if (insumo.cantidad <= insumo.cantidadMinima && !_notifiedInsumoIds.contains(insumo.id)) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String message =
          'Insumo ${insumo.nombre} del área de Limpieza llegó a cantidad mínima, debes rellenar el stock. Fecha: $formattedDate';
      SnackbarUtils.showSnackbar(context, message);
      _notifiedInsumoIds.add(insumo.id); // Agregar el ID del insumo al conjunto de notificados

      // Guardar el estado actual de _notifiedInsumoIds en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notifiedInsumoIds', _notifiedInsumoIds.toList());
    } else if (insumo.cantidad > insumo.cantidadMinima && _notifiedInsumoIds.contains(insumo.id)) {
      // Si la cantidad es mayor que cantidadMinima y el insumo estaba notificado, eliminarlo del conjunto de notificados
      _notifiedInsumoIds.remove(insumo.id);

      // Actualizar el estado en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notifiedInsumoIds', _notifiedInsumoIds.toList());
    }
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
    setState(() {
      _insumos.removeWhere((element) => element.id == insumo.id);
    });
  }

  void _navigateToInsumoSelectionScreen() async {
    final List<Insumo>? selectedInsumos = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsumoSelectionScreen(
          insumos: _insumos,
          updateParentScreen: () {
            _loadInsumos('limpieza');
          },
        ),
      ),
    );

    if (selectedInsumos != null) {
      logger.d('Insumos seleccionados: $selectedInsumos');
    }
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
        centerTitle: true,
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Insumos de Limpieza',
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_sharp, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductForm(
                    inventoryId: 'limpieza',
                    onInsumoAdded: (String nombre, int cantidad, int cantidadMinima) {
                      _loadInsumos('limpieza');
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
              title: Text(
                insumo.nombre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: insumo.cantidad <= insumo.cantidadMinima ? Colors.red : null,
                ),
              ),
              subtitle: Text(
                'Cantidad: ${insumo.cantidad}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
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
      floatingActionButton: OrderButton(
        onPressed: _navigateToInsumoSelectionScreen,
      ),
    );
  }
}
