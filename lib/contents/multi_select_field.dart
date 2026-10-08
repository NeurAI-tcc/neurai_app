import 'package:flutter/material.dart';

class MultiSelectField extends StatelessWidget {
  final List<String> selectedItems;
  final VoidCallback onTap;

  const MultiSelectField({
    super.key,
    required this.selectedItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 44,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 5,
                children: selectedItems.isEmpty
                    ? [
                        const Text(
                          'Selecione as condições',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFB5B5B5),
                          ),
                        ),
                      ]
                    : selectedItems.map(
                        (item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3EEFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5796E8),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFF5796E8),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: Color(0xFFADB5BC),
            ),
          ],
        ),
      ),
    );
  }
}