import 'package:baja_app/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baja_app/dominio/insumos.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:baja_app/dominio/notifications/snackbar_utils.dart';

class CleaningScreen extends StatefulWidget {
  const CleaningScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CleaningScreenState createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  List<Insumo> _insumos = [];

  @override
  void initState() {
    super.initState();
    _loadInsumos();
  }

  Future<void> _loadInsumos() async {
    List<Insumo> insumos = await FirebaseService.getInsumosFromDatabase('limpieza');
    setState(() {
      _insumos = insumos;
    });
  }

  void _incrementarCantidad(Insumo insumo) async {
    await FirebaseService.incrementarCantidadInsumo('limpieza', insumo.id);
    setState(() {
      insumo.cantidad++;
    });
    if (insumo.cantidad <= insumo.cantidadMinima) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String message = 'Insumo ${insumo.nombre} del área de Producción llegó a cantidad mínima, debes rellenar el stock. Fecha: $formattedDate';
      // ignore: use_build_context_synchronously
      SnackbarUtils.showSnackbar(context, message);
    }
  }

  void _decrementarCantidad(Insumo insumo) async {
    await FirebaseService.decrementarCantidadInsumo('limpieza', insumo.id);
    setState(() {
      if (insumo.cantidad > 0) {
        insumo.cantidad--;
      }
    });
    if (insumo.cantidad <= insumo.cantidadMinima) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      String message = 'Insumo ${insumo.nombre} del área de Producción llegó a cantidad mínima, debes rellenar el stock. Fecha: $formattedDate';
      // ignore: use_build_context_synchronously
      SnackbarUtils.showSnackbar(context, message);
    }
  }

  void _eliminarInsumo(Insumo insumo) async {
    await FirebaseService.eliminarInsumo('limpieza', insumo.id);
    setState(() {
      _insumos.removeWhere((element) => element.id == insumo.id);
    });
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
                      _loadInsumos();
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
    );
  }
}
