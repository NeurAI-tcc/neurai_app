import 'package:flutter/material.dart';
import 'package:neurai_app/views/cadastro_page.dart';
import 'package:neurai_app/views/esqueceu_senha.dart';
import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/services/auth_service.dart';

import 'contents/app_text_field.dart';
import 'contents/app_password_field.dart';
import 'contents/app_button.dart';
import 'contents/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  final AuthService authService = AuthService();

  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Elipse + bolinhas
                      Image.asset(
                        'assets/elipse.png',
                        width: 230,
                        height: 200,
                        fit: BoxFit.contain,
                      ),

                      // Logo por cima
                      Image.asset(
                        'assets/logo.png',
                        width: 200,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  // NOME NEURAI
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Image.asset(
                      'assets/neurai.png',
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: const Text(
                      'Tecnologia que entende você',
                      style: TextStyle(color: Color(0xFF4CAEBB), fontSize: 14),
                    ),
                  ),

                  const Text(
                    'Seja bem-vindo de volta!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    'Faça login para continuar.',
                    style: TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 20),

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

                  AppTextField(
                    hint: 'seu@email.com',
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),

                  const SizedBox(height: 15),

                  // SENHA
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

                  AppPasswordField(controller: senhaController),

                  const SizedBox(height: 13),

                  // BOTÃO
                  AppButton(
                    text: carregando ? 'Entrando...' : 'Entrar',
                    onPressed: carregando ? null : _entrar,
                  ),

                  const SizedBox(height: 17),

                  // ESQUECEU A SENHA
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EsqueceuSenhaPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: Color(0xFF3998B5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // CADASTRO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ainda não tem uma conta? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CadastroPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3998B5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Espaço para não deixar o conteúdo
                  // escondido atrás das ondas
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

  Future<void> _entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o e-mail e a senha.')),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      await authService.login(email, senha);

      if (!mounted) return;

      final token = await authService.token;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(cameraId: '', token: token ?? ''),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Não foi possível entrar: $e')));
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }
}
