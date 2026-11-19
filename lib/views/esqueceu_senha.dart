import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'contents/app_button.dart';
import 'contents/app_colors.dart';
import 'contents/app_password_field.dart';
import 'contents/app_text_field.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  const EsqueceuSenhaPage({super.key, AuthService? authService})
    : _authService = authService;

  final AuthService? _authService;

  @override
  State<EsqueceuSenhaPage> createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  late final AuthService _authService = widget._authService ?? AuthService();
  final _emailController = TextEditingController();
  final _codigoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  int _etapa = 0;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codigoController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titulo = switch (_etapa) {
      0 => 'Recuperar senha',
      1 => 'Verificar código',
      _ => 'Criar nova senha',
    };
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 24),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            titulo,
                            style: const TextStyle(
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
                  Image.asset(
                    'assets/cadeado.png',
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  if (_etapa == 0)
                    _emailStep()
                  else if (_etapa == 1)
                    _codeStep()
                  else
                    _passwordStep(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailStep() {
    return _formContent(
      title: 'Sem problemas!',
      description: 'Digite seu e-mail para receber o código de recuperação.',
      fields: [
        _label('E-mail'),
        const SizedBox(height: 5),
        AppTextField(
          hint: 'seu@email.com',
          icon: Icons.email_outlined,
          controller: _emailController,
        ),
      ],
      buttonText: 'Enviar código',
      onPressed: _enviarCodigo,
    );
  }

  Widget _codeStep() {
    return _formContent(
      title: 'Confira seu e-mail',
      description: 'Digite o código de 6 dígitos que enviamos para você.',
      fields: [
        _label('Código'),
        const SizedBox(height: 5),
        AppTextField(
          hint: '000000',
          icon: Icons.pin_outlined,
          controller: _codigoController,
        ),
      ],
      buttonText: 'Verificar código',
      onPressed: _verificarCodigo,
    );
  }

  Widget _passwordStep() {
    return _formContent(
      title: 'Escolha uma nova senha',
      description: 'Use pelo menos 6 caracteres.',
      fields: [
        _label('Nova senha'),
        const SizedBox(height: 5),
        AppPasswordField(controller: _senhaController),
        const SizedBox(height: 15),
        _label('Confirmar senha'),
        const SizedBox(height: 5),
        AppPasswordField(controller: _confirmarSenhaController),
      ],
      buttonText: 'Alterar senha',
      onPressed: _alterarSenha,
    );
  }

  Widget _formContent({
    required String title,
    required String description,
    required List<Widget> fields,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 35),
        ...fields,
        const SizedBox(height: 20),
        AppButton(
          text: _carregando ? 'Aguarde...' : buttonText,
          onPressed: _carregando ? null : onPressed,
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Align(
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

  Future<void> _enviarCodigo() async {
    final email = _emailController.text.trim();
    if (!_emailValido(email)) {
      _mostrar('Informe um e-mail válido.');
      return;
    }
    await _executar(() async {
      await _authService.solicitarRedefinicaoSenha(email);
      if (!mounted) return;
      setState(() => _etapa = 1);
      _mostrar('Código enviado. Confira sua caixa de entrada.');
    });
  }

  Future<void> _verificarCodigo() async {
    final codigo = _codigoController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(codigo)) {
      _mostrar('Digite o código de 6 dígitos.');
      return;
    }
    await _executar(() async {
      await _authService.verificarCodigoRedefinicao(
        _emailController.text,
        codigo,
      );
      if (mounted) setState(() => _etapa = 2);
    });
  }

  Future<void> _alterarSenha() async {
    final senha = _senhaController.text;
    final confirmar = _confirmarSenhaController.text;
    if (senha.length < 6) {
      _mostrar('A nova senha deve ter pelo menos 6 caracteres.');
      return;
    }
    if (senha != confirmar) {
      _mostrar('As senhas não conferem.');
      return;
    }
    await _executar(() async {
      await _authService.confirmarRedefinicaoSenha(
        email: _emailController.text,
        codigo: _codigoController.text,
        novaSenha: senha,
        confirmarSenha: confirmar,
      );
      if (!mounted) return;
      _mostrar('Senha alterada com sucesso.');
      Navigator.pop(context);
    });
  }

  Future<void> _executar(Future<void> Function() action) async {
    setState(() => _carregando = true);
    try {
      await action();
    } catch (error) {
      if (mounted) _mostrar(_mensagemErro(error));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrar(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  String _mensagemErro(Object error) {
    final mensagem = error.toString();
    return mensagem.startsWith('Exception: ')
        ? mensagem.substring('Exception: '.length)
        : mensagem;
  }

  bool _emailValido(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
