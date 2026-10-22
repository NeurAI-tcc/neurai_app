
import 'package:flutter/material.dart';
import 'perfil_card.dart';

class PerfilSeguranca extends StatelessWidget {
  const PerfilSeguranca({super.key});

  static const Color azul = Color(0xFF5298FF);

  Widget _opcao(
    BuildContext context, {
    required String titulo,
    required String valor,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$titulo: conecte aqui a funcionalidade correspondente.',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF858B94),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                valor,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF30343B),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: azul,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PerfilCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFE3F2FF),
                child: Icon(
                  Icons.shield,
                  color: azul,
                  size: 22,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Conta e segurança',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF30343B),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 21,
                color: Color(0xFF8D72FF),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _opcao(
            context,
            titulo: 'E-mail',
            valor: 'anapaula@gmail.com',
          ),
          const Divider(height: 1, thickness: 0.7),
          _opcao(
            context,
            titulo: 'Senha',
            valor: '',
          ),
          const Divider(height: 1, thickness: 0.7),
          _opcao(
            context,
            titulo: 'Privacidade',
            valor: 'Gerenciar compartilhamentos',
          ),
        ],
      ),
    );
  }
}
