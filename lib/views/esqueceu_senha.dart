import 'package:flutter/material.dart';

import 'contents/app_text_field.dart';
import 'contents/app_button.dart';
import 'contents/app_colors.dart';

class EsqueceuSenhaPage extends StatelessWidget {
  const EsqueceuSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Stack(
        children: [

          // =========================
          // CONTEÚDO
          // =========================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                children: [

                  // =========================
                  // TOPO
                  // =========================
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // LOGO
                  // =========================
                  Image.asset(
                    'assets/cadeado.png',
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // TÍTULO
                  // =========================
                  const Text(
                    'Sem problemas!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Digite seu e-mail para receber\nas instruções de recuperação.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // =========================
                  // E-MAIL
                  // =========================
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const AppTextField(
                    hint: 'seu@email.com',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 10),

                  // =========================
                  // BOTÃO
                  // =========================
                  AppButton(
                    text: 'Enviar instruções',
                    onPressed: () {
                      // futuramente: enviar e-mail de recuperação
                    },
                  ),

                  const SizedBox(height: 27),

                 
                ],
              ),
            ),
          ),

          // =========================
          // ONDAS
          // =========================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/ondas_fundo.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}