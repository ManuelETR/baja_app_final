import 'package:flutter/material.dart';

class OrderButtonEntries extends StatelessWidget {
  final VoidCallback onPressed;

  const OrderButtonEntries({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF053F93),
      child: const Icon(Icons.assignment_add, color: Colors.white),
    );
  }
}
