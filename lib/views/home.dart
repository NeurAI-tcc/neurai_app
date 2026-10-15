
import 'package:flutter/material.dart';

import 'contents/camera_ao_vivo.dart';

class HomePage extends StatelessWidget {
  final String cameraId;
  final String token;

  const HomePage({
    super.key,
    required this.cameraId,
    required this.token,
  });

  final String cameraNome = 'Câmera da sala';

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  static const Color turquesa = Color(0xFF62D4CB);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
          children: [
            // CABEÇALHO
            Row(
              children: const [
                Icon(
                  Icons.psychology_outlined,
                  color: Color(0xFF46C9CE),
                  size: 30,
                ),
                SizedBox(width: 5),
                Text(
                  'NeurAI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24364B),
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: azul,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Olá, Ariana!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              'Vamos cuidar juntos hoje.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 12),

            // CARTÃO DA CÂMERA
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: azul),
                boxShadow: [
                  BoxShadow(
                    color: azul.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitoramento ao vivo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // ESTE RETÂNGULO ABRE A CÂMERA
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
                    child: Container(
                      height: 132,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5EFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.videocam_outlined,
                              size: 55,
                              color: Color(0xFF5298FF),
                            ),
                          ),

                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 7,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'AO VIVO',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Positioned(
                            right: 8,
                            top: 8,
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
                ],
              ),
            ),

            const SizedBox(height: 10),

            // STATUS
            _statusCard(
              icone: Icons.verified_user_outlined,
              titulo: 'Tudo tranquilo',
              descricao: 'Nenhuma situação de risco detectada.',
              cor: const Color(0xFF078653),
              fundoIcone: const Color(0xFFC8F5D9),
            ),

            const SizedBox(height: 10),

            _statusCard(
              icone: Icons.gpp_maybe_outlined,
              titulo: 'Último alerta',
              descricao: 'Hoje, 10:32\nSaiu da área segura',
              cor: Colors.red.shade800,
              fundoIcone: const Color(0xFFFFD6D6),
            ),

            const SizedBox(height: 10),

            // RESUMO DO DIA
            Row(
              children: [
                Expanded(
                  child: _resumoCard(
                    icone: Icons.calendar_month_outlined,
                    titulo: 'Eventos hoje',
                    valor: '3 eventos',
                    acao: 'Ver histórico →',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _resumoCard(
                    icone: Icons.access_time,
                    titulo: 'Tempo acompanhado',
                    valor: '2h 45m',
                    acao: 'Ver relatório →',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          border: Border.all(color: azul),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _menuItem(Icons.home_outlined, 'Início', true),
              _menuItem(Icons.history, 'Histórico', false),
              _menuItem(Icons.calendar_month, 'Agenda', false),
              _menuItem(Icons.edit_note, 'Relatórios', false),
              _menuItem(Icons.person_outline, 'Perfil', false),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _statusCard({
    required IconData icone,
    required String titulo,
    required String descricao,
    required Color cor,
    required Color fundoIcone,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: azul),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
            child: Icon(icone, color: cor, size: 27),
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
                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 9,
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

  static Widget _resumoCard({
    required IconData icone,
    required String titulo,
    required String valor,
    required String acao,
  }) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: azul),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: const Color(0xFF8A63E8), size: 19),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              acao,
              style: const TextStyle(
                color: Color(0xFF8054D9),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuItem(
    IconData icone,
    String titulo,
    bool selecionado,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
            size: 22,
            color: selecionado
                ? const Color(0xFF4AA9C7)
                : Colors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 9,
              color: selecionado
                  ? const Color(0xFF4AA9C7)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
