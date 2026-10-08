import 'package:flutter/material.dart';

import '../models/cadastro_crianca_draft.dart';
import 'contents/app_button.dart';
import 'contents/app_colors.dart';
import 'contents/app_password_field.dart';
import 'contents/app_text_field.dart';
import 'paginas_de_crianca/cadastro_crianca.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _continuarCadastro() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _mostrarErro('Preencha nome, e-mail e senha.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroCriancaPage(
          cadastro: CadastroCriancaDraft(
            nomeCompleto: nome,
            email: email,
            senha: senha,
          ),
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 24),
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
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 50),
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
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 22),
                  const _FieldLabel('Nome completo'),
                  const SizedBox(height: 5),
                  AppTextField(
                    hint: 'Nome Completo',
                    icon: Icons.person_outline,
                    controller: _nomeController,
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel('E-mail'),
                  const SizedBox(height: 5),
                  AppTextField(
                    hint: 'seu@email.com',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel('Senha'),
                  const SizedBox(height: 5),
                  AppPasswordField(controller: _senhaController),
                  const SizedBox(height: 14),
                  AppButton(
                    text: 'Continuar cadastro',
                    onPressed: _continuarCadastro,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryText,
      ),
    ),
  );
}
