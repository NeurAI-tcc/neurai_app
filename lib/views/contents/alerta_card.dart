import 'package:flutter/material.dart';

class AlertaCard extends StatelessWidget {
  final String categoria;
  final String titulo;
  final String descricao;
  final String horario;
  final String data;

  const AlertaCard({
    super.key,
    required this.categoria,
    required this.titulo,
    required this.descricao,
    required this.horario,
    required this.data,
  });

  Color get corCategoria {
    switch (categoria) {
      case 'Rotina':
        return const Color(0xFFFFF0C2);
      case 'Saúde':
        return const Color(0xFFFFD6D9);
      case 'Medicamentos':
        return const Color(0xFFE8D8FF);
      default:
        return Colors.grey.shade200;
    }
  }

  Color get corIcone {
    switch (categoria) {
      case 'Rotina':
        return const Color(0xFFD6B500);
      case 'Saúde':
        return const Color(0xFFE94B58);
      case 'Medicamentos':
        return const Color(0xFF8054D9);
      default:
        return Colors.grey;
    }
  }

  IconData get icone {
    switch (categoria) {
      case 'Rotina':
        return Icons.notifications_active_outlined;
      case 'Saúde':
        return Icons.favorite_outline;
      case 'Medicamentos':
        return Icons.medication_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF65A8FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 70,
            decoration: BoxDecoration(
              color: corCategoria,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: corIcone,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: corCategoria,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    categoria,
                    style: TextStyle(
                      fontSize: 11,
                      color: corIcone,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  descricao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 10,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            horario,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}