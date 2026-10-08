import 'package:flutter/material.dart';

class FormField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextEditingController? controller;

  const FormField({
    super.key,
    required this.hint,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
        ),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(
          fontSize: 12,
        ),
        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB5B5B5),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),

          border: InputBorder.none,

          suffixIcon: icon != null
              ? Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFFADB5BC),
                )
              : null,
        ),
      ),
    );
  }
}