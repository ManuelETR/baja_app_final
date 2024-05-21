import 'package:baja_app/dominio/pedidos/pedido_history.dart';
import 'package:baja_app/services/firebase_service.dart';
import 'package:baja_app/widgets/login/toast.dart';
import 'package:flutter/material.dart';
import 'package:baja_app/dominio/insumos.dart';
import 'package:intl/intl.dart';

class InsumoSelectionScreen extends StatefulWidget {
  final List<Insumo> insumos;
  final Function() updateParentScreen;

  const InsumoSelectionScreen({super.key, required this.insumos, required this.updateParentScreen});

  @override
  _InsumoSelectionScreenState createState() => _InsumoSelectionScreenState();
}

class _InsumoSelectionScreenState extends State<InsumoSelectionScreen> {
  final Map<Insumo, TextEditingController> _textEditingControllerMap = {};
  late int _pedidoId;
  late String _nombrePedido = '';
  String _selectedArea = 'Producción'; // Valor predeterminado del área seleccionada

  @override
  void initState() {
    super.initState();
    _pedidoId = DateTime.now().millisecondsSinceEpoch;

    // Inicializar los controladores de texto para cada insumo
    for (var insumo in widget.insumos) {
      _textEditingControllerMap[insumo] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Liberar los controladores de texto cuando el widget se elimina
    for (var controller in _textEditingControllerMap.values) {
      controller.dispose();
    }
    super.dispose();
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
          'Generar un Pedido',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _revisarOrden,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre del Pedido',
                hintText: 'Introduce un nombre para el pedido',
              ),
              onChanged: (value) {
                setState(() {
                  _nombrePedido = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedArea,
              onChanged: (newValue) {
                setState(() {
                  _selectedArea = newValue!;
                });
              },
              items: ['Producción', 'Papelería', 'Limpieza'].map((area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(area),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.insumos.length,
              itemBuilder: (context, index) {
                Insumo insumo = widget.insumos[index];
                TextEditingController controller = _textEditingControllerMap[insumo]!;
                int cantidadSeleccionada = int.tryParse(controller.text) ?? 0;

                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(insumo.nombre),
                            Text('Cantidad actual: ${insumo.cantidad}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _updateCantidad(insumo, cantidadSeleccionada - 1);
                          });
                        },
                      ),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: '',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            int nuevaCantidad = int.tryParse(value) ?? 0;
                            if (nuevaCantidad < 0) {
                              controller.text = '0'; // Restablecer a 0 si el valor es negativo
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _updateCantidad(insumo, cantidadSeleccionada + 1);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateCantidad(Insumo insumo, int cantidad) {
    if (cantidad >= 0) {
      _textEditingControllerMap[insumo]!.text = cantidad.toString();
    }
  }

  void _revisarOrden() {
    if (_nombrePedido.isEmpty) {
      showToast(message: 'Por favor, introduce un nombre para el pedido.');
      return;
    }

    Map<Insumo, int> selectedInsumos = {};
    _textEditingControllerMap.forEach((insumo, controller) {
      int cantidad = int.tryParse(controller.text) ?? 0;
      if (cantidad > 0) {
        selectedInsumos[insumo] = cantidad;
      }
    });

    if (selectedInsumos.isEmpty) {
      showToast(message: 'Por favor, selecciona al menos un insumo.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resumen de la Orden'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre del Pedido: $_nombrePedido'),
              Text('ID del Pedido: $_pedidoId'),
              const SizedBox(height: 10),
              ...selectedInsumos.entries.map((entry) {
                return Text('${entry.key.nombre}: ${entry.value}');
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _finalizarPedido(selectedInsumos);
              },
              child: const Text('Confirmar Pedido'),
            ),
          ],
        );
      },
    );
  }

  void _finalizarPedido(Map<Insumo, int> selectedInsumos) async {
    String areaSeleccionada = _selectedArea.toLowerCase(); // Convertir a minúsculas y quitar diacríticos
    areaSeleccionada = quitarDiacriticos(areaSeleccionada);

    // Actualizar las cantidades de los insumos seleccionados en Firestore
    for (var entry in selectedInsumos.entries) {
      Insumo insumo = entry.key;
      int cantidadSeleccionada = entry.value;
      int nuevaCantidad = insumo.cantidad - cantidadSeleccionada; // Restar la cantidad seleccionada

      // Actualizar la cantidad en Firestore con el nombre del área ajustado
      await FirebaseService.actualizarCantidadInsumo(areaSeleccionada, insumo.id, nuevaCantidad);
    }

    // Agregar el pedido al historial
    PedidoHistory.addPedido(_generarResumenOrden(selectedInsumos));

    // Llamar a la función de actualización de la pantalla anterior
    widget.updateParentScreen();

    // Limpiar los valores de los controladores de texto
    for (var controller in _textEditingControllerMap.values) {
      controller.clear();
    }

    // Reiniciar el nombre del pedido
    setState(() {
      _nombrePedido = '';
    });

    // Volver a la pantalla anterior a InsumoSelectionScreen
    Navigator.pop(context);
  }

  String _generarResumenOrden(Map<Insumo, int> selectedInsumos) {
    // Obtener la fecha y hora actual
    String fechaHoraActual = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Generar el resumen de la orden
    String resumen = 'Nombre del Pedido: $_nombrePedido\n';
    resumen += 'ID del Pedido: $_pedidoId\n';
    resumen += 'Área seleccionada: $_selectedArea\n'; // Agregar el área seleccionada

    // Agregar la fecha y hora de la orden
    resumen += 'Fecha y hora de la orden: $fechaHoraActual\n';

    // Agregar los insumos y cantidades seleccionadas
    selectedInsumos.forEach((insumo, cantidadSeleccionada) {
      resumen += '${insumo.nombre}: $cantidadSeleccionada\n';
    });
    return resumen;
  }

  String quitarDiacriticos(String input) {
    return input
        .replaceAll(RegExp(r'[áÁ]'), 'a')
        .replaceAll(RegExp(r'[éÉ]'), 'e')
        .replaceAll(RegExp(r'[íÍ]'), 'i')
        .replaceAll(RegExp(r'[óÓ]'), 'o')
        .replaceAll(RegExp(r'[úÚ]'), 'u');
  }
}
