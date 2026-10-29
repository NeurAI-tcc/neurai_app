
import 'package:flutter/material.dart';
import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/calendario_semanal.dart';
import 'contents/evento_card.dart';
import 'contents/titulo_secao_agenda.dart';
import 'historico_page.dart';
import 'perfil_page.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);

  DateTime dataSelecionada = DateTime(2026, 9, 3);

  final List<Map<String, String>> eventos = [
    {
      'titulo': 'Terapia ABA',
      'horario': '09:00 - 10:00',
      'local': 'Clínica Vida - Sala 2',
      'data': '2026-09-03',
    },
    {
      'titulo': 'Fonoaudiologia',
      'horario': '11:00 - 11:45',
      'local': 'Clínica Vida - Sala 1',
      'data': '2026-09-03',
    },
    {
      'titulo': 'Almoço',
      'horario': '12:30 - 13:15',
      'local': 'Rotina diária',
      'data': '2026-09-03',
    },
    {
      'titulo': 'Terapia Ocupacional',
      'horario': '14:00 - 15:00',
      'local': 'Clínica Vida - Sala 3',
      'data': '2026-09-03',
    },
    {
      'titulo': 'Momento Sensorial',
      'horario': '14:00 - 15:00',
      'local': 'Atividade em casa',
      'data': '2026-09-03',
    },
    {
      'titulo': 'Consulta de acompanhamento',
      'horario': '10:00 - 11:00',
      'local': 'Clínica Vida',
      'data': '2026-09-04',
    },
  ];

  List<Map<String, String>> get eventosDoDia {
    final dataFormatada =
        '${dataSelecionada.year.toString().padLeft(4, '0')}-'
        '${dataSelecionada.month.toString().padLeft(2, '0')}-'
        '${dataSelecionada.day.toString().padLeft(2, '0')}';

    return eventos
        .where((evento) => evento['data'] == dataFormatada)
        .toList();
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

  void abrirNovoEvento() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Formulário de novo evento ainda não foi criado.',
        ),
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
                      border: Border.all(
                        color: azul,
                        width: 0.8,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFD5EFFF),
                      child: Icon(
                        Icons.person,
                        size: 18,
                        color: azul,
                      ),
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
                        dataSelecionada = DateTime(
                          dataSelecionada.year,
                          mes,
                          1,
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
                  dataSelecionada = data;
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                  else
                    ...lista.map(
                      (evento) => EventoCard(
                        titulo: evento['titulo']!,
                        horario: evento['horario']!,
                        local: evento['local']!,
                      ),
                    ),

                  const SizedBox(height: 5),

                  const Padding(
                    padding: EdgeInsets.only(
                      left: 6,
                      bottom: 14,
                    ),
                    child: Text(
                      'Próximos eventos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  ...eventos
                      .where(
                        (evento) =>
                            evento['data']!.compareTo(
                              '${dataSelecionada.year.toString().padLeft(4, '0')}-'
                              '${dataSelecionada.month.toString().padLeft(2, '0')}-'
                              '${dataSelecionada.day.toString().padLeft(2, '0')}',
                            ) > 0,
                      )
                      .take(3)
                      .map(
                        (evento) => EventoCard(
                          titulo: evento['titulo']!,
                          horario: evento['horario']!,
                          local: evento['local']!,
                        ),
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
                  builder: (_) => const HomePage(cameraId: '', token: '',),
                ),
              );
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
