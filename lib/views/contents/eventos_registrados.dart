
import 'package:flutter/material.dart';
import 'package:neurai_app/views/contents/titulo_card.dart';

class EventosRegistradosCard extends StatelessWidget {
  const EventosRegistradosCard({super.key});

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

          const _Evento(
            titulo: 'Sessão de terapia',
            data: '10 mai, 2026 - 14:00',
            icone: Icons.calendar_month,
            cor: Color(0xFFF0E6FF),
            iconeCor: Color(0xFF8955BA),
          ),

          const SizedBox(height: 5),

          const _Evento(
            titulo: 'Passeio no parque',
            data: '12 mai, 2026 - 16:30',
            icone: Icons.person,
            cor: Color(0xFFBFF2D1),
            iconeCor: Color(0xFF43BF80),
          ),

          const SizedBox(height: 5),

          const _Evento(
            titulo: 'Aula de música',
            data: '13 mai, 2026 - 10:00',
            icone: Icons.person,
            cor: Color(0xFFE5F4FF),
            iconeCor: Color(0xFF5997E4),
          ),
        ],
      ),
    );
  }
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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
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
