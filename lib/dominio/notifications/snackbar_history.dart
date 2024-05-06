import 'package:shared_preferences/shared_preferences.dart';

class SnackBarHistory {
  static const String key = 'snackbar_history'; // Definimos la constante key

  static Future<List<String>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> addMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messages = prefs.getStringList(key) ?? [];
    messages.add(message);
    await prefs.setStringList(key, messages);
  }

  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
