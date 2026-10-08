import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppPasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;

  const AppPasswordField({
    super.key,
    this.hint = '••••••••••',
    this.controller,
  });

  @override
  State<AppPasswordField> createState() =>
      _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,

      obscureText: obscureText,

      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Color.fromARGB(184, 158, 158, 158)),

        prefixIcon: const Icon(
          Icons.lock_outline,
          size: 26,
          color: Color.fromARGB(132, 158, 158, 158),
        ),

        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 26,
            color: const Color.fromARGB(132, 158, 158, 158),
          ),

          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 25,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.blue,
          ),
        ),
      ),
    );
  }
}