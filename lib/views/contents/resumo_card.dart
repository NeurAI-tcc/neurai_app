
import 'package:flutter/material.dart';

class ResumoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;
  final String acao;
  final Color cor;

  const ResumoCard({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
    required this.acao,
    required this.cor,
  });

  static const Color azul = Color(0xFF5298FF);
  static const Color roxo = Color(0xFF8054D9);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: azul,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 32,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icone,
                  color: cor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.05,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          Center(
            child: Text(
              acao,
              style: TextStyle(
                color: cor == azul ? azul : roxo,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
