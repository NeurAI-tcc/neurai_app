import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const Option({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF5796E8),
                width: 3,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5796E8),
                      ),
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 8),

          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}