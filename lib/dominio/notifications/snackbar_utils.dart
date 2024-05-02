import 'package:baja_app/dominio/notifications/snackbar_history.dart';
import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Agregar el mensaje a la lista de historial
    SnackBarHistory.addMessage(message);
  }
}