import 'package:flutter/material.dart';
import 'package:baja_app/dominio/insumos.dart';

class InsumoSelectionScreen extends StatefulWidget {
  final List<Insumo> insumos;

  const InsumoSelectionScreen({Key? key, required this.insumos}) : super(key: key);

  @override
  _InsumoSelectionScreenState createState() => _InsumoSelectionScreenState();
}

class _InsumoSelectionScreenState extends State<InsumoSelectionScreen> {
  final Map<Insumo, TextEditingController> _textEditingControllerMap = {};
  late int _pedidoId;
  late String _nombrePedido = '';

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
        title: const Text('Seleccionar Insumos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _revisarOrden();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
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
                        child: Text(insumo.nombre),
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
                        width: 60, // Ajusta el ancho del TextFormField según sea necesario
                        child: TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: '', // No muestra el 0 inicial
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
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
    _textEditingControllerMap[insumo]!.text = cantidad.toString();
  }

  void _revisarOrden() {
    Map<Insumo, int> _selectedInsumos = {};
    _textEditingControllerMap.forEach((insumo, controller) {
      int cantidad = int.tryParse(controller.text) ?? 0;
      if (cantidad > 0) {
        _selectedInsumos[insumo] = cantidad;
      }
    });

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
              const SizedBox(height: 10),
              ..._selectedInsumos.entries.map((entry) {
                return Text('${entry.key.nombre}: ${entry.value}');
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Limpiar los valores de los controladores de texto
                _textEditingControllerMap.values.forEach((controller) {
                  controller.clear();
                });
                setState(() {
                  _nombrePedido = '';
                });
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar la acción de finalizar el pedido
                // ...
                _finalizarPedido();
                Navigator.pop(context);
              },
              child: const Text('Confirmar Pedido'),
            ),
          ],
        );
      },
    );
  }

  void _finalizarPedido() {
    // Aquí puedes finalizar el pedido
  }
}
