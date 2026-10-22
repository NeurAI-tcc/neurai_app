import 'package:flutter/material.dart';
import 'package:neurai_app/views/historico_page.dart';
import 'package:neurai_app/views/perfil_page.dart';

import 'contents/camera_monitoramento.dart';
import 'contents/home_bottom_nav.dart';
import 'contents/resumo_card.dart';
import 'contents/status_card.dart';

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
                Image.asset(
                  'assets/group_neurai.png',
                  width: 135,
                  height: 50,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomLeft,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: azul,
                      width: 0.8,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFD5EFFF),
                    child: Icon(
                      Icons.person,
                      size: 25,
                      color: azul,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Olá, Ariana!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'Vamos cuidar juntos hoje.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 11),

            // CÂMERA
            CameraMonitoramentoCard(
              cameraId: cameraId,
              token: token,
              nomeCamera: cameraNome,
            ),

            const SizedBox(height: 9),

            // STATUS
            const StatusCard(
              icone: Icons.verified_user_outlined,
              titulo: 'Tudo tranquilo',
              descricao:
                  'AO VIVO\nNenhuma situação de risco detectada.',
              cor: Color(0xFF078653),
              fundoIcone: Color(0xFFC8F5D9),
            ),

            const SizedBox(height: 15),

            // ÚLTIMO ALERTA
            const StatusCard(
              icone: Icons.gpp_maybe_outlined,
              titulo: 'Último alerta',
              descricao: 'Hoje, 10:32\nSaiu da área segura',
              cor: Color(0xFFB60000),
              fundoIcone: Color(0xFFFFD6D6),
            ),

            const SizedBox(height: 15),

            // RESUMOS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: ResumoCard(
                    icone: Icons.calendar_month_outlined,
                    titulo: 'Eventos hoje',
                    valor: '3 eventos',
                    acao: 'Ver histórico →',
                    cor: roxo,
                  ),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: ResumoCard(
                    icone: Icons.access_time,
                    titulo: 'Tempo\nacompanhado',
                    valor: '2h 45m',
                    acao: 'Ver relatório →',
                    cor: azul,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoricoPage(),
                ),
              );
              break;
            case 2:
              // Abrir Agenda
              break;
            case 3:
              // Abrir Relatórios
              break;
            case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PerfilPage(cameraId: '', token: '',),
              ),
            );
              break;
          }
        },
      ),
    );
  }
}
