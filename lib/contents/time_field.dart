import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final String hint;
  final TimeOfDay? value;
  final VoidCallback onTap;

  const TimeField({
    super.key,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  String formatarHora(TimeOfDay hora) {
    final String hour = hora.hour.toString().padLeft(2, '0');
    final String minute = hora.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD0D0D0),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value == null
                    ? hint
                    : formatarHora(value!),
                style: TextStyle(
                  fontSize: 13,
                  color: value == null
                      ? const Color(0xFFB5B5B5)
                      : const Color(0xFF444444),
                ),
              ),
            ),

            const Icon(
              Icons.access_time_outlined,
              size: 22,
              color: Color(0xFFADB5BC),
            ),
          ],
        ),
      ),
    );
  }
}