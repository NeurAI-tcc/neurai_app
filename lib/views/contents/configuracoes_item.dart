import 'package:flutter/material.dart';

class ConfiguracoesItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final bool mostrarDivisor;
  final VoidCallback onTap;

  const ConfiguracoesItem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.mostrarDivisor = true,
    required this.onTap,
  });

  static const Color azul = Color(0xFF5298FF);
  static const Color texto = Color(0xFF263746);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                // Ícone circular ampliado
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5F4FC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icone,
                    color: azul,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Textos do Item
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: texto,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descricao,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87, // Cor mais escura para dar leitura
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Seta da direita
                const Icon(
                  Icons.chevron_right_rounded,
                  color: azul,
                  size: 28,
                ),
              ],
            ),
          ),
          if (mostrarDivisor)
            Divider(
              height: 1,
              thickness: 1,
              indent: 18,
              endIndent: 18,
              color: Colors.grey.withOpacity(0.15),
            ),
        ],
      ),
    );
  }
}