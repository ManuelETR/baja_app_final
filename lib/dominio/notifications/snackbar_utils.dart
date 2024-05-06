import 'package:flutter/material.dart';
import 'package:baja_app/dominio/notifications/snackbar_history.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Agregar el mensaje a la lista de historial
    await SnackBarHistory.addMessage(message);
  }
}