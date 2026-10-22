
import 'package:flutter/material.dart';

class PerfilBotaoSair extends StatelessWidget {
  final VoidCallback onConfirmarSaida;

  const PerfilBotaoSair({
    super.key,
    required this.onConfirmarSaida,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmar = await showDialog<bool>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('sair da conta?'),
                content: const Text(
                  'tem certeza de que deseja sair da sua conta?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                    },
                    child: const Text('cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                    },
                    child: const Text('sair'),
                  ),
                ],
              );
            },
          );

          if (confirmar == true && context.mounted) {
            onConfirmarSaida();
          }
        },
        icon: const Icon(
          Icons.logout,
          size: 19,
          color: Color(0xFF5298FF),
        ),
        label: const Text(
          'Sair da Conta',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF30343B),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF5298FF),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
