
import 'package:flutter/material.dart';
import 'perfil_card.dart';

class PerfilSobre extends StatelessWidget {
  const PerfilSobre({super.key});

  static const Color azul = Color(0xFF5298FF);
  static const Color texto = Color(0xFF30343B);
  static const Color cinza = Color(0xFF858B94);

  Widget _campo({
    required String titulo,
    required String valor,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
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
          if (trailing != null) trailing,
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
                  Icons.person,
                  color: azul,
                  size: 24,
                ),
              ),
              SizedBox(width: 9),
              Text(
                'Sobre',
                style: TextStyle(
                  fontSize: 12,
                  color: texto,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _campo(
            titulo: 'Data de nascimento',
            valor: '12/04/2017',
          ),
          const Divider(height: 1, thickness: 0.7),
          _campo(
            titulo: 'Responsável principal',
            valor: 'Ariana (Mãe)',
            trailing: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('contato do responsável'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.phone_in_talk_outlined,
                  color: azul,
                  size: 20,
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 0.7),
          _campo(
            titulo: 'E-mail',
            valor: 'ariana@gmail.com',
          ),
        ],
      ),
    );
  }
}
