import 'package:flutter/material.dart';

import 'contents/configuracoes_cartao.dart';
import 'contents/configuracoes_item.dart';
import 'contents/configuracoes_secao.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  static const Color azul = Color(0xFF5298FF);
  static const Color fundo = Color(0xFFE8F6FF);
  static const Color texto = Color(0xFF263746);

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _criarItem(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String descricao,
    bool mostrarDivisor = true,
  }) {
    return ConfiguracoesItem(
      icone: icone,
      titulo: titulo,
      descricao: descricao,
      mostrarDivisor: mostrarDivisor,
      onTap: () {
        _mostrarMensagem(
          context,
          '$titulo: configure a navegação desta opção.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            Row(
              children: [
                Material(
                  color: const Color.fromRGBO(77, 190, 215, 0),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 52,
                      height: 52,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: texto,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Configurações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: texto,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // CARTÃO DO PERFIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF405C6D).withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5F4FC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 36,
                      color: azul,
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ariana',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: texto,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '8 anos',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'TEA - Nível 1 de suporte',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: azul,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // MONITORAMENTO
            const ConfiguracoesSecao(
              titulo: 'Monitoramento',
            ),
            const SizedBox(height: 15),
            ConfiguracoesCartao(
              filhos: [
                _criarItem(
                  context,
                  icone: Icons.camera_alt_outlined,
                  titulo: 'Câmeras e dispositivos',
                  descricao: 'Gerencie as câmeras conectadas',
                ),
                _criarItem(
                  context,
                  icone: Icons.notifications_none_rounded,
                  titulo: 'Alertas e notificações',
                  descricao: 'Personalize como e quando receber alertas',
                ),
                _criarItem(
                  context,
                  icone: Icons.access_time_rounded,
                  titulo: 'Horários de silêncio',
                  descricao: 'Defina períodos sem notificações',
                ),
                _criarItem(
                  context,
                  icone: Icons.shield_outlined,
                  titulo: 'Privacidade',
                  descricao: 'Gerencie acesso, dados e segurança',
                  mostrarDivisor: false,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ROTINA E PREFERÊNCIAS
            const ConfiguracoesSecao(
              titulo: 'Rotina e preferências',
            ),
            const SizedBox(height: 12),
            ConfiguracoesCartao(
              filhos: [
                _criarItem(
                  context,
                  icone: Icons.calendar_month_outlined,
                  titulo: 'Rotina do neurodivergente',
                  descricao: 'Horários, terapias e atividades recorrentes',
                ),
                _criarItem(
                  context,
                  icone: Icons.favorite_border_rounded,
                  titulo: 'Preferências sensoriais',
                  descricao: 'Ajuste de estímulos, sons e ambientes',
                ),
                _criarItem(
                  context,
                  icone: Icons.star_outline_rounded,
                  titulo: 'Interesses e reforçadores',
                  descricao: 'Cadastre preferências que ajudam no dia a dia',
                  mostrarDivisor: false,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // CONTA
            const ConfiguracoesSecao(
              titulo: 'Conta',
            ),
            const SizedBox(height: 12),
            ConfiguracoesCartao(
              filhos: [
                _criarItem(
                  context,
                  icone: Icons.health_and_safety_outlined,
                  titulo: 'Central de ajuda',
                  descricao: 'Dúvidas, tutoriais e suporte',
                ),
                _criarItem(
                  context,
                  icone: Icons.info_outline_rounded,
                  titulo: 'Sobre o NeurAI',
                  descricao: 'Versão do aplicativo e informações',
                  mostrarDivisor: false,
                ),
              ],
            ),

            const SizedBox(height: 36),

            // SAIR DA CONTA
            SizedBox(
              height: 60,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text(
                          'Sair da conta',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Deseja realmente sair da sua conta?',
                          style: TextStyle(fontSize: 17),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _mostrarMensagem(
                                context,
                                'Conecte aqui sua função de logout.',
                              );
                            },
                            child: const Text(
                              'Sair',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 26,
                ),
                label: const Text(
                  'Sair da conta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF7F7),
                  foregroundColor: const Color(0xFFE53946),
                  side: BorderSide(
                    color: const Color(0xFFE53946).withOpacity(0.30),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}