import 'package:flutter/material.dart';

class GrupoAlertas extends StatelessWidget {
  final String titulo;

  const GrupoAlertas({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 7,
      ),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF454545),
        ),
      ),
    );
  }
}