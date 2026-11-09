import 'package:flutter/material.dart';

class CalendarioSemanal extends StatelessWidget {
  final DateTime dataSelecionada;
  final ValueChanged<DateTime> onSelecionarData;

  const CalendarioSemanal({
    super.key,
    required this.dataSelecionada,
    required this.onSelecionarData,
  });

  static const Color azul = Color(0xFF1689F8);

  static DateTime inicioDaSemana(DateTime data) {
    final dataNormalizada = DateTime(data.year, data.month, data.day);
    return dataNormalizada.subtract(
      Duration(days: dataNormalizada.weekday % DateTime.daysPerWeek),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inicioSemana = inicioDaSemana(dataSelecionada);

    final dias = List.generate(
      7,
      (index) => inicioSemana.add(Duration(days: index)),
    );

    const nomesDias = {
      DateTime.sunday: 'DOM',
      DateTime.monday: 'SEG',
      DateTime.tuesday: 'TER',
      DateTime.wednesday: 'QUA',
      DateTime.thursday: 'QUI',
      DateTime.friday: 'SEX',
      DateTime.saturday: 'SÁB',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: dias.map((dia) {
          final selecionado =
              dia.year == dataSelecionada.year &&
              dia.month == dataSelecionada.month &&
              dia.day == dataSelecionada.day;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelecionarData(dia),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: selecionado ? azul : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nomesDias[dia.weekday] ?? 'DIA',
                      style: TextStyle(
                        fontSize: 12,
                        color: selecionado
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dia.day.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selecionado
                            ? Colors.white
                            : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: selecionado ? Colors.white : azul,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
