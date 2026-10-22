
import 'package:flutter/material.dart';

import 'home.dart';
import 'contents/home_bottom_nav.dart';
import 'contents/perfil_header.dart';
import 'contents/perfil_sobre.dart';
import 'contents/perfil_clinico.dart';
import 'contents/perfil_seguranca.dart';
import 'contents/perfil_botao_sair.dart';

class PerfilPage extends StatelessWidget {
  final String cameraId;
  final String token;

  const PerfilPage({
    super.key,
    required this.cameraId,
    required this.token,
  });

  static const Color fundo = Color(0xFFE8F6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PerfilHeader(),
                    const SizedBox(height: 12),
                    const PerfilSobre(),
                    const SizedBox(height: 12),
                    const PerfilClinico(),
                    const SizedBox(height: 20),
                    const PerfilSeguranca(),
                    const SizedBox(height: 20),
                    PerfilBotaoSair(
                      onConfirmarSaida: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'conecte esta ação ao serviço de logout.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(
                  cameraId: cameraId,
                  token: token,
                ),
              ),
            );
          } else if (index != 4) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${HomeBottomNav.titulos[index]} ainda precisa '
                  'ser conectada.',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
