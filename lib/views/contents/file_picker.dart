import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String? fileName;

  const FilePickerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 36,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5796E8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        if (fileName != null) ...[
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.insert_drive_file_outlined,
                size: 16,
                color: Color(0xFF5796E8),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  fileName!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}