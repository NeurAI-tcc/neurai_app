
import 'package:flutter/material.dart';

class PerfilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PerfilCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  static const Color azul = Color(0xFF5298FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: azul,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5298FF).withValues(alpha: 0.13),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
