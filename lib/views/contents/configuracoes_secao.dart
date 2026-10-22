import 'package:flutter/material.dart';

class ConfiguracoesSecao extends StatelessWidget {
  final String titulo;

  const ConfiguracoesSecao({
    super.key,
    required this.titulo,
  });

  static const Color texto = Color(0xFF263746);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 6, bottom: 2),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: texto,
        ),
      ),
    );
  }
}