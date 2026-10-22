
import 'package:flutter/material.dart';

class ConfiguracoesCartao extends StatelessWidget {
  final List<Widget> filhos;

  const ConfiguracoesCartao({
    super.key,
    required this.filhos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF456575).withValues(alpha: 0.16),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: filhos,
      ),
    );
  }
}
