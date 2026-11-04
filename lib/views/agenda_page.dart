import 'package:flutter/material.dart';
import '../controllers/agenda_controller.dart';
import '../models/agenda_model.dart';
import '../services/auth_service.dart';
import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/calendario_semanal.dart';
import 'contents/evento_card.dart';
import 'contents/titulo_secao_agenda.dart';
import 'contents/evento_form.dart';
import 'historico_page.dart';
import 'perfil_page.dart';

class AgendaPage extends StatefulWidget {
  final String token;
  final String cameraId;
  const AgendaPage({super.key, this.token = '', this.cameraId = ''});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  late final AgendaController controller;

  DateTime get dataSelecionada => controller.diaSelecionado;
  List<EventoModel> get eventosDoDia => controller.eventos;

  @override
  void initState() {
    super.initState();
    controller = AgendaController();
    controller.addListener(_atualizar);
    if (widget.token.isNotEmpty) {
      controller.carregarEventos(widget.token);
    }
  }

  void _atualizar() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_atualizar);
    controller.dispose();
    super.dispose();
  }

  String get nomeMes {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${meses[dataSelecionada.month - 1]} de '
        '${dataSelecionada.year}';
  }

  String get dataPorExtenso {
    const dias = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo',
    ];

    const meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    final diaSemana = dias[dataSelecionada.weekday - 1];
    final mes = meses[dataSelecionada.month - 1];

    return '${diaSemana[0].toUpperCase()}'
        '${diaSemana.substring(1)}, '
        '${dataSelecionada.day.toString().padLeft(2, '0')} de $mes';
  }

  Future<void> abrirNovoEvento() async {
    final token = widget.token.isNotEmpty
        ? widget.token
        : await AuthService().token ?? '';
    if (token.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token não encontrado. Faça login novamente.'),
          ),
        );
      }
      return;
    }
    if (!mounted) return;
    final evento = await showDialog<EventoModel>(
      context: context,
      builder: (_) => EventoFormDialog(dataInicial: dataSelecionada),
    );
    if (evento == null || !mounted) return;
    final salvo = await controller.criarEvento(token, evento);
    if (!mounted || salvo) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(controller.erro ?? 'Não foi possível salvar o evento.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = eventosDoDia;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Agenda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF292929),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: azul, width: 0.8),
                    ),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFD5EFFF),
                      child: Icon(Icons.person, size: 18, color: azul),
                    ),
                  ),
                ],
              ),
            ),

            // MÊS SELECIONADO
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
              child: Row(
                children: [
                  Text(
                    nomeMes,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(width: 5),
                  PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 17,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF555555),
                    ),
                    onSelected: (mes) {
                      setState(() {
                        controller.carregarEventos(
                          widget.token,
                          dia: DateTime(dataSelecionada.year, mes, 1),
                        );
                      });
                    },
                    itemBuilder: (context) => List.generate(
                      12,
                      (index) => PopupMenuItem<int>(
                        value: index + 1,
                        child: Text(
                          [
                            'Janeiro',
                            'Fevereiro',
                            'Março',
                            'Abril',
                            'Maio',
                            'Junho',
                            'Julho',
                            'Agosto',
                            'Setembro',
                            'Outubro',
                            'Novembro',
                            'Dezembro',
                          ][index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CALENDÁRIO REUTILIZÁVEL
            CalendarioSemanal(
              dataSelecionada: dataSelecionada,
              onSelecionarData: (data) {
                setState(() {
                  controller.carregarEventos(widget.token, dia: data);
                });
              },
            ),

            // TÍTULO DA DATA E BOTÃO
            TituloSecaoAgenda(
              titulo: dataPorExtenso,
              onNovoEvento: abrirNovoEvento,
            ),

            // LISTA DE EVENTOS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(17, 2, 17, 12),
                children: [
                  if (lista.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'Nenhum evento para este dia.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    )
                  else
                    ...lista.map(
                      (evento) => EventoCard(
                        titulo: evento.titulo,
                        horario: _horario(evento),
                        local: evento.localizacao,
                      ),
                    ),

                  const SizedBox(height: 5),

                  const Padding(
                    padding: EdgeInsets.only(left: 6, bottom: 14),
                    child: Text(
                      'Próximos eventos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  if (controller.carregando)
                    const Center(child: CircularProgressIndicator()),
                  if (controller.erro != null)
                    Text(
                      controller.erro!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HomePage(cameraId: widget.cameraId, token: widget.token),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricoPage(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatoriosScreen(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilPage(
                    cameraId: widget.cameraId,
                    token: widget.token,
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  String _horario(EventoModel evento) {
    String formatar(DateTime data) =>
        '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    return '${formatar(evento.inicio)} - ${formatar(evento.fim)}';
  }
}
