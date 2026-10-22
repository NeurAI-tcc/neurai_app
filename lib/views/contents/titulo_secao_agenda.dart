
import 'package:flutter/material.dart';

class TituloSecaoAgenda extends StatelessWidget {
  final String titulo;
  final VoidCallback onNovoEvento;

  const TituloSecaoAgenda({
    super.key,
    required this.titulo,
    required this.onNovoEvento,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(7),
              onTap: onNovoEvento,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Color(0xFF1689F8),
                    ),
                    Text(
                      'Novo evento',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1689F8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
