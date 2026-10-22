
import 'package:flutter/material.dart';
import 'package:neurai_app/views/home.dart';

import 'agenda_page.dart';
import 'historico_page.dart';
import 'perfil_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/resumo_da_semana_card.dart';
import 'contents/eventos_registrados.dart';
import 'contents/insights_semana_card.dart';
import 'contents/baixar_relatorio_card.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  static const Color fundo = Color(0xFFE8F5FF);
  static const Color azul = Color(0xFF5298FF);
  static const Color texto = Color(0xFF263746);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      body: SafeArea(
        child: Column(
          children: [
            // CONTEÚDO DA PÁGINA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  15,
                  20,
                  15,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CABEÇALHO
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Relatórios',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: texto,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: azul,
                              width: 0.8,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/avatar.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return const Icon(
                                    Icons.person,
                                    color: Color(0xFF649AC9),
                                    size: 22,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // PERÍODO DO RELATÓRIO
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF8CC5FF),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Color(0xFF547DA7),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '07 - 13 set. 2026',
                            style: TextStyle(
                              fontSize: 11,
                              color: texto,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 15,
                            color: texto,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RESUMO DA SEMANA
                    const ResumoSemanaCard(),

                    const SizedBox(height: 12),

                    // EVENTOS REGISTRADOS
                    const EventosRegistradosCard(),

                    const SizedBox(height: 12),

                    // INSIGHTS DA SEMANA
                    const InsightsSemanaCard(),

                    const SizedBox(height: 12),

                    // DOWNLOAD DO RELATÓRIO
                    const BaixarRelatorioCard(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(cameraId: '', token: '',),
                ),
              );
              break;

            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoricoPage(),
                ),
              );
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const AgendaPage(),
                ),
              );
              break;

            case 3:
              // Já está na página de relatórios.
              break;

            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const PerfilPage(
                    cameraId: '',
                    token: '',
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
