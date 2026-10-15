
import 'package:flutter/material.dart';
import 'package:neurai_app/models/cadastro_crianca_draft.dart';

class CadastroCameraPage extends StatefulWidget {
  const CadastroCameraPage({super.key, required this.cadastro});

  final CadastroCriancaDraft cadastro;

  @override
  State<CadastroCameraPage> createState() => _CadastroCameraPageState();
}

class _CadastroCameraPageState extends State<CadastroCameraPage> {
  final formKey = GlobalKey<FormState>();

  final ipController = TextEditingController();
  final nomeController = TextEditingController();
  final localizacaoController = TextEditingController();
  final modeloController = TextEditingController();
  bool salvando = false;

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  static const Color turquesa = Color(0xFF62D4CB);

  @override
  void dispose() {
    ipController.dispose();
    nomeController.dispose();
    localizacaoController.dispose();
    modeloController.dispose();
    super.dispose();
  }

  String? validarCampo(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }
    return null;
  }

  Future<void> continuar() async {
    if (salvando) return;
    if (!formKey.currentState!.validate()) return;

    widget.cadastro.setCamera({
      'endereco_ip': ipController.text.trim(),
      'nome': nomeController.text.trim(),
      'localizacao': localizacaoController.text.trim(),
      'modelo': modeloController.text.trim(),
    });

    setState(() => salvando = true);
    try {
      await widget.cadastro.salvar();
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível concluir o cadastro: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Stack(
          children: [
            // Ondas decorativas no rodapé.
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

            // Conteúdo da página.
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho.
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF263746),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.psychology_outlined,
                                color: turquesa,
                                size: 30,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Registrar câmera',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF252B32),
                            ),
                          ),

                          const SizedBox(height: 9),

                          const Text(
                            'Adicione o IP da sua câmera de\n'
                            'monitoramento e preencha as informações\n'
                            'para identificá-la.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color(0xFF525D68),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Ilustração da câmera.
                          Center(
                            child: Container(
                              width: 114,
                              height: 114,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD0F0FF),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/camera.png',
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(
                                    Icons.videocam_outlined,
                                    size: 58,
                                    color: azul,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 17),

                          _campo(
                            titulo: 'Endereço IP da câmera',
                            controller: ipController,
                            hint: '192.168.1.10',
                            teclado: TextInputType.url,
                            validator: (valor) {
                              final erro = validarCampo(
                                valor,
                                'o endereço IP',
                              );
                              if (erro != null) return erro;

                              final ip = valor!.trim();
                              final partes = ip.split('.');

                              final ipValido = partes.length == 4 &&
                                  partes.every((parte) {
                                    final numero = int.tryParse(parte);
                                    return numero != null &&
                                        numero >= 0 &&
                                        numero <= 255;
                                  });

                              if (!ipValido) {
                                return 'Digite um endereço IPv4 válido.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 13),

                          _campo(
                            titulo: 'Nome da câmera',
                            controller: nomeController,
                            hint: 'Ex: Quarto',
                            validator: (valor) =>
                                validarCampo(valor, 'o nome da câmera'),
                          ),

                          const SizedBox(height: 13),

                          _campo(
                            titulo: 'Localização',
                            controller: localizacaoController,
                            hint: 'Ex: Quarto da criança',
                            validator: (valor) =>
                                validarCampo(valor, 'a localização'),
                          ),

                          const SizedBox(height: 13),

                          _campo(
                            titulo: 'Modelo da câmera',
                            controller: modeloController,
                            hint: 'Ex: Intelbras iM3',
                            validator: (valor) =>
                                validarCampo(valor, 'o modelo da câmera'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Botão fixo acima das ondas.
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA8F1D9),
                          Color(0xFF5298FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: salvando ? null : continuar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF292929),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: salvando
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Cadastrar câmera',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo({
    required String titulo,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType teclado = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A5058),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 43,
          child: TextFormField(
            controller: controller,
            keyboardType: teclado,
            validator: validator,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFACACAC),
                fontSize: 12,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFD6DCE2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFD6DCE2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: azul,
                  width: 1.3,
                ),
              ),
              errorStyle: const TextStyle(fontSize: 9),
            ),
          ),
        ),
      ],
    );
  }
}
