import 'package:flutter/material.dart';
import 'package:baja_app/dominio/notifications/snackbar_history.dart'; // Importa la clase SnackBarHistory

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
    final messages = await SnackBarHistory.getMessages(); // Utiliza el método getMessages de SnackBarHistory
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
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(messages[index]),
            ),
          );
        },
      ),
    );
  }

  void _clearMessages() async {
    await SnackBarHistory.clearMessages(); // Utiliza el método clearMessages de SnackBarHistory
    setState(() {
      messages = [];
    });
  }
}
