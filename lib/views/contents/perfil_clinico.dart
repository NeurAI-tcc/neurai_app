
import 'package:flutter/material.dart';
import 'perfil_card.dart';

class PerfilClinico extends StatelessWidget {
  const PerfilClinico({super.key});

  static const Color azul = Color(0xFF5298FF);
  static const Color cinza = Color(0xFF858B94);
  static const Color texto = Color(0xFF30343B);

  Widget _linha({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE3F2FF),
            child: Icon(
              icone,
              size: 22,
              color: azul,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 10,
                    color: cinza,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 12,
                    color: texto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PerfilCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFE3F2FF),
                child: Icon(
                  Icons.favorite,
                  color: azul,
                  size: 23,
                ),
              ),
              SizedBox(width: 9),
              Text(
                'Informações clínicas',
                style: TextStyle(
                  fontSize: 12,
                  color: texto,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _linha(
            icone: Icons.monitor_heart,
            titulo: 'Diagnóstico',
            valor: 'TEA - Nível 1',
          ),
          const Divider(height: 1, thickness: 0.7),
          _linha(
            icone: Icons.hearing,
            titulo: 'Sensibilidades',
            valor: 'Luz, barulho alto, texturas',
          ),
          const Divider(height: 1, thickness: 0.7),
          _linha(
            icone: Icons.star,
            titulo: 'Preferências',
            valor: 'Músicas, brinquedos, rotina fixa',
          ),
        ],
      ),
    );
  }
}
