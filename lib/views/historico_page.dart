
import 'package:flutter/material.dart';
import '../controllers/alertas_controller.dart';
import '../models/alerta_model.dart';
import 'package:neurai_app/views/agenda_page.dart';
import 'package:neurai_app/views/contents/group_alertas.dart';
import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/filtro_alertas.dart';
import 'contents/alerta_card.dart';
import 'perfil_page.dart';

class HistoricoPage extends StatefulWidget {
  final String token;
  final String cameraId;
  const HistoricoPage({super.key, this.token = '', this.cameraId = ''});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  late final AlertasController controller;

  String filtroSelecionado = 'Todos';

  final List<Map<String, dynamic>> alertas = [];
  /*
    {
      'categoria': 'Rotina',
      'titulo': 'Mudança na rotina detectada',
      'descricao': 'O almoço foi fora do horário habitual.',
      'horario': '12:45',
      'data': '25 de maio de 2026',
      'grupo': 'Hoje',
    },
    {
      'categoria': 'Saúde',
      'titulo': 'Possível crise comportamental',
      'descricao': 'Padrão de comportamento incomum detectado.',
      'horario': '07:48',
      'data': '25 de maio de 2026',
      'grupo': 'Hoje',
    },
    {
      'categoria': 'Medicamentos',
      'titulo': 'Dose não registrada',
      'descricao': 'A dose das 20:00 não foi confirmada.',
      'horario': '20:05',
      'data': '25 de maio de 2026',
      'grupo': 'Hoje',
    },
    {
      'categoria': 'Rotina',
      'titulo': 'Atividade não realizada',
      'descricao': 'A atividade "Terapia Ocupacional" não foi realizada.',
      'horario': '19:12',
      'data': '24 de maio de 2026',
      'grupo': 'Ontem - 24 de maio de 2026',
    },
    {
      'categoria': 'Rotina',
      'titulo': 'Rotina concluída',
      'descricao': 'Todas as atividades do dia foram concluídas.',
      'horario': '04:13',
      'data': '24 de maio de 2026',
      'grupo': 'Ontem - 24 de maio de 2026',
    },
    {
      'categoria': 'Rotina',
      'titulo': 'Atraso na atividade',
      'descricao': 'A atividade "Escola" iniciou com atraso.',
      'horario': '22:23',
      'data': '23 de maio de 2026',
      'grupo': 'Ontem - 23 de maio de 2026',
    },
    {
      'categoria': 'Rotina',
      'titulo': 'Anotação adicionada na rotina',
      'descricao': 'Foi adicionada uma nova anotação ao diário.',
      'horario': '21:02',
      'data': '23 de maio de 2026',
      'grupo': 'Ontem - 23 de maio de 2026',
    },
    {
      'categoria': 'Saúde',
      'titulo': 'Possível crise comportamental',
      'descricao': 'Padrão de comportamento incomum detectado.',
      'horario': '20:05',
      'data': '23 de maio de 2026',
      'grupo': 'Ontem - 23 de maio de 2026',
    },
    {
      'categoria': 'Medicamentos',
      'titulo': 'Dose não registrada',
      'descricao': 'A dose das 20:00 não foi confirmada.',
      'horario': '20:05',
      'data': '23 de maio de 2026',
      'grupo': 'Ontem - 23 de maio de 2026',
    },
  */

  @override
  void initState() {
    super.initState();
    controller = AlertasController();
    controller.addListener(_atualizar);
    if (widget.token.isNotEmpty) controller.carregar(widget.token);
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

  List<Map<String, dynamic>> get alertasFiltrados {
    if (filtroSelecionado == 'Todos') {
      return alertas;
    }

    return alertas
        .where(
          (alerta) => alerta['categoria'] == filtroSelecionado,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lista = controller.alertas.map(_mapearAlerta).toList();

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Histórico de alertas',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
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

            // FILTROS REUTILIZÁVEIS
            FiltroAlertas(
              selecionado: filtroSelecionado,
              onChanged: (filtro) {
                setState(() => filtroSelecionado = filtro);
                if (widget.token.isNotEmpty) {
                  controller.aplicarFiltro(widget.token, _filtroApi(filtro));
                }
              },
            ),

            const SizedBox(height: 8),

            // LISTA DE ALERTAS
            Expanded(
              child: lista.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum alerta nesta categoria.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        12,
                      ),
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final alerta = lista[index];

                        final mostrarGrupo = index == 0 ||
                            lista[index - 1]['grupo'] !=
                                alerta['grupo'];

                        return Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // TÍTULO DO DIA REUTILIZÁVEL
                            if (mostrarGrupo)
                              GrupoAlertas(
                                titulo: alerta['grupo'],
                              ),

                            // CARD REUTILIZÁVEL
                            AlertaCard(
                              categoria: alerta['categoria'],
                              titulo: alerta['titulo'],
                              descricao: alerta['descricao'],
                              horario: alerta['horario'],
                              data: alerta['data'],
                            ),

                            const SizedBox(height: 7),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 1,
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
              
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaPage(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
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

  TipoAlertaFiltro _filtroApi(String filtro) => switch (filtro) {
    'Rotina' => TipoAlertaFiltro.rotina,
    'Saúde' => TipoAlertaFiltro.saude,
    'Medicamentos' => TipoAlertaFiltro.medicamentos,
    _ => TipoAlertaFiltro.todos,
  };

  Map<String, dynamic> _mapearAlerta(AlertaModel alerta) {
    final local = alerta.timestamp.toLocal();
    final categoria = alerta.tipoCrise.isEmpty
        ? 'Saúde'
        : alerta.tipoCrise[0].toUpperCase() + alerta.tipoCrise.substring(1);
    return {
      'categoria': categoria,
      'titulo': alerta.detalhes.isEmpty ? 'Alerta registrado' : alerta.tipoCrise,
      'descricao': alerta.detalhes,
      'horario': '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}',
      'data': '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}',
      'grupo': '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}',
    };
  }
}
