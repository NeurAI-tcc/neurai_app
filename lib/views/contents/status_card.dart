
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final Color cor;
  final Color fundoIcone;

  const StatusCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.fundoIcone,
  });

  static const Color azul = Color(0xFF5298FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: azul,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.12),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: fundoIcone,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icone,
              color: cor,
              size: 27,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
