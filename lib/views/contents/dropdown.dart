import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final VoidCallback onTap;

  const DropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
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
        readOnly: true,
        onTap: onTap,
        controller: TextEditingController(
          text: value ?? '',
        ),
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

          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Color(0xFFADB5BC),
          ),
        ),
      ),
    );
  }
}