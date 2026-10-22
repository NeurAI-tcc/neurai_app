import 'package:flutter/material.dart';

class FiltroAlertas extends StatelessWidget {
  final String selecionado;
  final ValueChanged<String> onChanged;

  const FiltroAlertas({
    super.key,
    required this.selecionado,
    required this.onChanged,
  });

  static const filtros = [
    'Todos',
    'Rotina',
    'Saúde',
    'Medicamentos',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: filtros.map((filtro) {
          final ativo = selecionado == filtro;

          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ChoiceChip(
              label: Text(filtro),
              selected: ativo,
              onSelected: (_) => onChanged(filtro),
              showCheckmark: false,
              labelStyle: TextStyle(
                fontSize: 12,
                color: ativo ? Colors.white : Colors.black54,
              ),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF1689F8),
              side: BorderSide(
                color: ativo
                    ? const Color(0xFF1689F8)
                    : const Color(0xFFE5E9EF),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 0,
              ),
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
            ),
          );
        }).toList(),
      ),
    );
  }
}