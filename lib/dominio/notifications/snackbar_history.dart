class SnackBarHistory {
  static List<String> _messages = [];

  static void addMessage(String message) {
    _messages.add(message);
  }

  static List<String> getMessages() {
    return _messages;
  }

  static void clearMessages() {
    _messages.clear();
  }
}