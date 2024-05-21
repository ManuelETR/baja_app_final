import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key});

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
          'Registro de Historial',
          style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ButtonSection();
  }
}

class _ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButtonH(
            icon: Icons.assignment_add,
            text: 'Historial de\nEntradas',
            onPressed: () {
              Navigator.pushNamed(context, '/activityEntries');
            },
          ),
          CustomButtonH(
            icon: Icons.assignment_rounded,
            text: 'Historial de\nPedidos',
            onPressed: () {
              Navigator.pushNamed(context, '/activityOut');
            },
          ),
        ],
      ),
    );
  }
}

class CustomButtonH extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;

  const CustomButtonH({
    Key? key,
    required this.icon,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 80),
        const VerticalDivider(),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
