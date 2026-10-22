
import 'package:flutter/material.dart';
import 'titulo_card.dart';

class InsightsSemanaCard extends StatelessWidget {
  const InsightsSemanaCard({super.key});

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
        children: const [
          TituloCard('Principais insights da semana'),
          SizedBox(height: 8),

          _Insight(
            icone: Icons.access_time,
            cor: Color(0xFFE5F4FF),
            iconeCor: Color(0xFF4D8FE8),
            texto:
                'Ariana ficou a maior parte do tempo em situações tranquilas.',
          ),

          SizedBox(height: 6),

          _Insight(
            icone: Icons.extension,
            cor: Color(0xFFE5F4FF),
            iconeCor: Color(0xFF508DE1),
            texto:
                'Houve 2 alertas severos. Fique atento aos horários de maior agitação.',
          ),
        ],
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  final IconData icone;
  final Color cor;
  final Color iconeCor;
  final String texto;

  const _Insight({
    required this.icone,
    required this.cor,
    required this.iconeCor,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icone,
            color: iconeCor,
            size: 23,
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              texto,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 14,
                height: 1.3,
                color: Color(0xFF46515B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
