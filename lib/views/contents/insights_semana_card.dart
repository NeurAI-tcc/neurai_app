
import 'package:flutter/material.dart';
import '../../models/relatorio_model.dart';
import 'titulo_card.dart';

class InsightsSemanaCard extends StatelessWidget {
  final RelatorioModel? relatorio;
  const InsightsSemanaCard({super.key, this.relatorio});

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
          const TituloCard('Principais insights da semana'),
          const SizedBox(height: 8),
          if (relatorio?.insights.isEmpty ?? true)
            const Text('Nenhum insight disponível.')
          else
            ...relatorio!.insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _Insight(
                icone: Icons.insights,
                cor: const Color(0xFFE5F4FF),
                iconeCor: const Color(0xFF4D8FE8),
                texto: insight,
              ),
            )),
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
