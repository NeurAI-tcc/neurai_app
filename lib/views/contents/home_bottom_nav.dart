import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  final int paginaSelecionada;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.paginaSelecionada,
    required this.onTap,
  });

  static const Color azul = Color(0xFF5298FF);
  static const Color turquesa = Color(0xFF4AA9C7);

  static const List<IconData> icones = [
    Icons.home_outlined,
    Icons.history,
    Icons.calendar_month_outlined,
    Icons.edit_note,
    Icons.person_outline,
  ];

  static const List<String> titulos = [
    'Início',
    'Histórico',
    'Agenda',
    'Relatórios',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        border: Border.all(color: azul, width: 1),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(
              titulos.length,
              (index) {
                final selecionado = paginaSelecionada == index;
                final cor = selecionado ? turquesa : Colors.grey;

                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icones[index],
                            size: 30,
                            color: cor,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            titulos[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: cor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}