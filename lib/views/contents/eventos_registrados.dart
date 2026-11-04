import 'package:flutter/material.dart';
import '../../models/agenda_model.dart';
import '../../models/relatorio_model.dart';
import 'package:neurai_app/views/contents/titulo_card.dart';

class EventosRegistradosCard extends StatelessWidget {
  final RelatorioModel? relatorio;
  const EventosRegistradosCard({super.key, this.relatorio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloCard('Eventos registrados'),
          const SizedBox(height: 8),

          if (relatorio?.eventosDetalhados.isEmpty ?? true)
            const Text('Nenhum evento registrado.')
          else
            ...relatorio!.eventosDetalhados.map(
              (evento) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: _Evento(
                  titulo: evento.titulo,
                  data: _formatar(evento),
                  icone: Icons.calendar_month,
                  cor: const Color(0xFFF0E6FF),
                  iconeCor: const Color(0xFF8955BA),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatar(EventoModel evento) =>
      '${evento.inicio.day.toString().padLeft(2, '0')}/'
      '${evento.inicio.month.toString().padLeft(2, '0')}/${evento.inicio.year} - '
      '${evento.inicio.hour.toString().padLeft(2, '0')}:'
      '${evento.inicio.minute.toString().padLeft(2, '0')}';
}

class _Evento extends StatelessWidget {
  final String titulo;
  final String data;
  final IconData icone;
  final Color cor;
  final Color iconeCor;

  const _Evento({
    required this.titulo,
    required this.data,
    required this.icone,
    required this.cor,
    required this.iconeCor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            icone,
            color: iconeCor,
            size: 22, // Aumenta o ícone
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13, // Antes: 10
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 11, // Antes: 8
                    color: Color(0xFF58636D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
