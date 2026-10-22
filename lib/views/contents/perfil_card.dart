
import 'package:flutter/material.dart';

class PerfilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PerfilCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  static const Color azul = Color(0xFF5298FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: azul, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
