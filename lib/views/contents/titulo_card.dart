import 'package:flutter/material.dart';

class TituloCard extends StatelessWidget {
  final String texto;

  const TituloCard(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF46515B),
      ),
    );
  }
}