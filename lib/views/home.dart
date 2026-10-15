import 'package:flutter/material.dart';

import 'contents/camera_ao_vivo.dart';
import 'contents/home_bottom_nav.dart';

class HomePage extends StatelessWidget {
  final String cameraId;
  final String token;

  const HomePage({
    super.key,
    required this.cameraId,
    required this.token,
  });

  static const String cameraNome = 'Câmera da sala';

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  static const Color texto = Color(0xFF24364B);
  static const Color roxo = Color(0xFF8054D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            // CABEÇALHO
            Row(
              children: [
                const Icon(
                  Icons.psychology_outlined,
                  color: Color(0xFF46C9CE),
                  size: 29,
                ),
                const SizedBox(width: 4),
                const Text(
                  'NeurAI',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: texto,
                    letterSpacing: -0.8,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: azul, width: 1),
                  ),
                  child: const CircleAvatar(
                    radius: 11,
                    backgroundColor: Color(0xFFD5EFFF),
                    child: Icon(
                      Icons.person,
                      size: 17,
                      color: azul,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Olá, Ariana!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              'Vamos cuidar juntos hoje.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 11),

            // MONITORAMENTO AO VIVO
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: azul, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: azul.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monitoramento ao vivo',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 6),

                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraAoVivoCard(
                            cameraId: cameraId,
                            token: token,
                            nomeCamera: cameraNome,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 132,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraStreamPreview(
                              cameraId: cameraId,
                              token: token,
                            ),

                            Positioned(
                              left: 7,
                              bottom: 7,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '🔴 AO VIVO',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const Positioned(
                              right: 6,
                              top: 6,
                              child: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 9),

            // STATUS: TUDO TRANQUILO
            _statusCard(
              icone: Icons.verified_user_outlined,
              titulo: 'Tudo tranquilo',
              descricao:
                  'AO VIVO\nNenhuma situação de risco detectada.',
              cor: const Color(0xFF078653),
              fundoIcone: const Color(0xFFC8F5D9),
            ),

            const SizedBox(height: 9),

            // ÚLTIMO ALERTA
            _statusCard(
              icone: Icons.gpp_maybe_outlined,
              titulo: 'Último alerta',
              descricao: 'Hoje, 10:32\nSaiu da área segura',
              cor: const Color(0xFFB60000),
              fundoIcone: const Color(0xFFFFD6D6),
            ),

            const SizedBox(height: 10),

            // RESUMO DO DIA
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _resumoCard(
                    icone: Icons.calendar_month_outlined,
                    titulo: 'Eventos hoje',
                    valor: '3 eventos',
                    acao: 'Ver histórico →',
                    cor: roxo,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _resumoCard(
                    icone: Icons.access_time,
                    titulo: 'Tempo\nacompanhado',
                    valor: '2h 45m',
                    acao: 'Ver relatório →',
                    cor: azul,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),

      // MENU INFERIOR REUTILIZÁVEL
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Página inicial
              break;
            case 1:
              // TODO: abrir Histórico
              break;
            case 2:
              // TODO: abrir Agenda
              break;
            case 3:
              // TODO: abrir Relatórios
              break;
            case 4:
              // TODO: abrir Perfil
              break;
          }
        },
      ),
    );
  }

  // CARTÕES DE STATUS
  static Widget _statusCard({
    required IconData icone,
    required String titulo,
    required String descricao,
    required Color cor,
    required Color fundoIcone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: azul, width: 1),
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 9,
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

  // CARTÕES DE RESUMO
  static Widget _resumoCard({
    required IconData icone,
    required String titulo,
    required String valor,
    required String acao,
    required Color cor,
  }) {
    return Container(
      height: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: azul, width: 1),
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icone,
                  color: cor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 9,
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
              fontSize: 12,
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
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PRÉVIA DA CÂMERA
class CameraStreamPreview extends StatelessWidget {
  final String cameraId;
  final String token;

  const CameraStreamPreview({
    super.key,
    required this.cameraId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    // Substitua pelo widget que exibe a transmissão real.
    // Este conteúdo é apenas um placeholder visual.
    return Container(
      color: Colors.black12,
      child: const Center(
        child: Icon(
          Icons.videocam,
          size: 50,
          color: Colors.black38,
        ),
      ),
    );
  }
}