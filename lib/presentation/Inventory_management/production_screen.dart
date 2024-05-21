import 'package:baja_app/dominio/insumos.dart';
import 'package:baja_app/dominio/notifications/snackbar_utils.dart';
import 'package:baja_app/presentation/index.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:baja_app/widgets/pedido/order_button.dart';
import 'package:baja_app/widgets/pedido/order_button_entries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductionScreenState createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  List<Insumo> _insumos = [];
  Set<String> _notifiedInsumoIds = <String>{};
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadInsumos('produccion');
  }

  Future<void> _loadInsumos(String inventoryId) async {
    List<Insumo> insumos = await FirebaseService.getInsumosFromDatabase(inventoryId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String>? notifiedInsumoIds = prefs.getStringList('notifiedInsumoIds')?.toSet() ?? {};

    setState(() {
      _insumos = insumos;
      _notifiedInsumoIds = notifiedInsumoIds;
    });

    for (var insumo in _insumos) {
      _verificarCantidadMinima(insumo);
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
        backgroundColor: const Color(0xFF053F93),
        title: const Text(
          'Insumos de Producción',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                      _loadInsumos('produccion');
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
            color: insumo.cantidad == 0 ? Colors.grey[700] : 
            insumo.cantidad <= insumo.cantidadMinima ? Colors.pink[100] : null,
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OrderButton(
              onPressed: () {
                _navigateToInsumoSelectionScreenP();
              },
            ),
            const SizedBox(height: 16), // Espacio entre los botones
            OrderButtonEntries(
              onPressed: () {
                _navigateToInsumoSelectionScreenEntriesP();
              },
            ),
          ],
        ),
    );
  }

  void _incrementarCantidad(Insumo insumo) async {
    await FirebaseService.incrementarCantidadInsumo('produccion', insumo.id);
    setState(() {
      insumo.cantidad++;
    });
    _verificarCantidadMinima(insumo);
  }

  void _decrementarCantidad(Insumo insumo) async {
    if (insumo.cantidad > 0) {
      await FirebaseService.decrementarCantidadInsumo('produccion', insumo.id);
      setState(() {
        insumo.cantidad--;
      });
      _verificarCantidadMinima(insumo);
    } else {
      _mostrarAlertaCantidadNoValida();
    }
  }

  void _mostrarAlertaCantidadNoValida() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cantidad no válida'),
          content: const Text('La cantidad no puede ser menor a 0. El insumo está vacío.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _verificarCantidadMinima(Insumo insumo) async {
    if (insumo.cantidad <= insumo.cantidadMinima && !_notifiedInsumoIds.contains(insumo.id)) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String message =
          'Insumo ${insumo.nombre} del área de Producción llegó a cantidad mínima, debes rellenar el stock. Fecha: $formattedDate';
      SnackbarUtils.showSnackbar(context, message);
      _notifiedInsumoIds.add(insumo.id);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notifiedInsumoIds', _notifiedInsumoIds.toList());
    } else if (insumo.cantidad > insumo.cantidadMinima && _notifiedInsumoIds.contains(insumo.id)) {
      _notifiedInsumoIds.remove(insumo.id);

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
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _eliminarInsumoConfirmed(insumo);
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarInsumoConfirmed(Insumo insumo) async {
    await FirebaseService.eliminarInsumo('produccion', insumo.id);
    setState(() {
      _insumos.removeWhere((element) => element.id == insumo.id);
    });
  }

  void _navigateToInsumoSelectionScreenP() async {
    final List<Insumo>? selectedInsumos = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsumoSelectionScreen(
          insumos: _insumos,
          updateParentScreen: () {
            _loadInsumos('produccion');
          },
        ),
      ),
    );
    
    if (selectedInsumos != null) {
      logger.d('Insumos seleccionados: $selectedInsumos');
    }
  }

    void _navigateToInsumoSelectionScreenEntriesP() async {
    final List<Insumo>? selectedInsumos = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsumoEntradaScreen(
          insumos: _insumos,
          updateParentScreen: () {
            _loadInsumos('produccion');
          },
        ),
      ),
    );
    
    if (selectedInsumos != null) {
      logger.d('Insumos seleccionados: $selectedInsumos');
    }
  }

}
