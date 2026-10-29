import 'package:flutter/material.dart';
import 'package:neurai_app/views/agenda_page.dart';
import 'package:neurai_app/views/historico_page.dart';

import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/views/configuracoes_page.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/perfil_header.dart';
import 'contents/perfil_sobre.dart';
import 'contents/perfil_clinico.dart';
import 'contents/perfil_seguranca.dart';
import 'contents/perfil_botao_sair.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

class PerfilPage extends StatelessWidget {
  final String cameraId;
  final String token;

  const PerfilPage({super.key, required this.cameraId, required this.token});

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);

  void _abrirConfiguracoes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ConfiguracoesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // CABEÇALHO DO PERFIL
                    const PerfilHeader(),

                    const SizedBox(height: 16),

                    // BOTÃO DE CONFIGURAÇÕES
                    _botaoConfiguracoes(context),

                    const SizedBox(height: 16),

                    // INFORMAÇÕES SOBRE O USUÁRIO
                    const PerfilSobre(),

                    const SizedBox(height: 12),

                    // INFORMAÇÕES CLÍNICAS
                    const PerfilClinico(),

                    const SizedBox(height: 20),

                    // SEGURANÇA DA CONTA
                    const PerfilSeguranca(),

                    const SizedBox(height: 20),

                    // SAIR DA CONTA
                    PerfilBotaoSair(
                      onConfirmarSaida: () async {
                        try {
                          await AuthService().logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível sair da conta.'),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(cameraId: cameraId, token: token),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoricoPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgendaPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RelatoriosScreen(),
                ),
              );
              break;
            case 4:
              // Já está na página de perfil
              break;
          }
        },
      ),
    );
  }

  // BOTÃO DE CONFIGURAÇÕES
  Widget _botaoConfiguracoes(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _abrirConfiguracoes(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: azul.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: fundo,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: azul,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configurações',
                      style: TextStyle(
                        color: Color(0xFF263746),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Personalize sua experiência no NeurAI',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded, color: azul, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
