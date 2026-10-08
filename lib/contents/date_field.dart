import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final String hint;
  final DateTime? value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  String get formattedDate {
    if (value == null) {
      return '';
    }

    final day = value!.day.toString().padLeft(2, '0');
    final month = value!.month.toString().padLeft(2, '0');
    final year = value!.year.toString();

    return '$day/$month/$year';
  }

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
          text: formattedDate,
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
            Icons.calendar_today_outlined,
            size: 18,
            color: Color(0xFFADB5BC),
          ),
        ),
      ),
    );
  }
}