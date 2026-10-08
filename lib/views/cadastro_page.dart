import 'package:flutter/material.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_crianca.dart';

import 'contents/app_text_field.dart';
import 'contents/app_password_field.dart';
import 'contents/app_button.dart';
import 'contents/app_colors.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

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
                            'Cadastre-se',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Espaço para centralizar o título
                      const SizedBox(width: 24),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // =========================
                  // LOGO
                  // =========================
                  Image.asset(
                    'assets/logo.png',
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Vamos começar!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Preencha seus dados para criar\nsua conta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =========================
                  // NOME
                  // =========================
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome completo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const AppTextField(
                    hint: 'Nome Completo',
                    icon: Icons.person_outline,),

                  const SizedBox(height: 14),

                  // E-MAIL
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

                  const SizedBox(height: 14),

                  // =========================
                  // SENHA
                  // =========================
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const AppPasswordField(),

                  const SizedBox(height: 14),

                  // =========================
                  // BOTÃO
                  // =========================
                  AppButton(
                    text: 'Criar conta',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CadastroCriancaPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

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