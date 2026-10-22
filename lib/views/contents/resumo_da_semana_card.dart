
import 'package:flutter/material.dart';
import 'titulo_card.dart';

class ResumoSemanaCard extends StatelessWidget {
  const ResumoSemanaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloCard('Resumo da semana'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _Indicador(
                  cor: Color(0xFFE6F5FF),
                  icone: Icons.camera_alt_outlined,
                  valor: '2h40m',
                  descricao: 'Tempo\nregistrado',
                  iconeCor: Color(0xFF508DE1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Indicador(
                  cor: Color(0xFFFFB5B8),
                  icone: Icons.gpp_maybe_outlined,
                  valor: '2',
                  descricao: 'Alertas\nregistrados',
                  iconeCor: Color(0xFFE53935),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Indicador(
                  cor: Color(0xFFF0E7FF),
                  icone: Icons.calendar_month,
                  valor: '5',
                  descricao: 'Eventos\nregistrados',
                  iconeCor: Color(0xFF8659B9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final Color cor;
  final Color iconeCor;
  final IconData icone;
  final String valor;
  final String descricao;

  const _Indicador({
    required this.cor,
    required this.iconeCor,
    required this.icone,
    required this.valor,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icone,
            color: iconeCor,
            size: 30, // Aumentado de 19 para 26
          ),
          const SizedBox(height: 3),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF303840),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.1,
              color: Color(0xFF58636D),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.10),
        blurRadius: 7,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
