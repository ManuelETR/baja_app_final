import 'package:flutter/material.dart';
import 'package:baja_app/dominio/notifications/snackbar_history.dart'; 

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final messages = await SnackBarHistory.getMessages(); 
    setState(() {
      this.messages = messages;
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
          'Historial de Avisos',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white, size: 30),
            onPressed: _clearMessages,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFC0CB), // Color rosa pastel
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.notification_important, color: Color(0xFF053F93)), // Icono decorativo
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      messages[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Texto en negrita
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearMessages() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Borrar Historial'),
          content: const Text('¿Quieres borrar todo el historial de mensajes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _confirmClearMessages();
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearMessages() async {
    await SnackBarHistory.clearMessages(); 
    setState(() {
      messages = [];
    });
  }
}
