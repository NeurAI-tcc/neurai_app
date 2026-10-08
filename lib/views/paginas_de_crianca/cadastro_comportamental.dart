import 'package:flutter/material.dart' hide FormField;
import 'package:neurai_app/models/cadastro_crianca_draft.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_rotina.dart';

import '../contents/app_colors.dart';
import '../contents/continue_button.dart';
import '../contents/dropdown.dart';
import '../contents/form_field.dart';
import '../contents/text_area.dart';

class CadastroComportamentoPage extends StatefulWidget {
  const CadastroComportamentoPage({super.key, required this.cadastro});

  final CadastroCriancaDraft cadastro;

  @override
  State<CadastroComportamentoPage> createState() =>
      _CadastroComportamentoPageState();
}

class _CadastroComportamentoPageState
    extends State<CadastroComportamentoPage> {

  String? comunicacaoSelecionada;

  @override
  void initState() {
    super.initState();
    comunicacaoSelecionada =
        widget.cadastro.valores['comunicacao'] as String?;
  }

  Future<void> selecionarComunicacao() async {
    final String? resultado = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Como a criança se comunica?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Fala'),
                onTap: () {
                  Navigator.pop(context, 'Fala');
                },
              ),

              ListTile(
                title: const Text('Comunicação não verbal'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Comunicação não verbal',
                  );
                },
              ),

              ListTile(
                title: const Text('Libras'),
                onTap: () {
                  Navigator.pop(context, 'Libras');
                },
              ),

              ListTile(
                title: const Text('Comunicação alternativa'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Comunicação alternativa',
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (resultado != null) {
      setState(() {
        comunicacaoSelecionada = resultado;
        widget.cadastro.setValue('comunicacao', resultado);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      size: 22,
                    ),
                  ),

                  const Spacer(),

                  Image.asset(
                    'assets/logo.png',
                    width: 65,
                    height: 65,
                  ),
                ],
              ),

              const Text(
                'Cadastro da criança',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const ChildStepIndicator(
                currentStep: 4,
              ),

              const SizedBox(height: 18),

              const Text(
                'Preferências e comportamentos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Conte-nos mais sobre o que acalma, o que\n'
                'incomoda e como é a rotina da criança.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // ATIVIDADES FAVORITAS
              // =========================

              const Text(
                'Atividades favoritas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              FormField(
                hint: 'Ex.: ouvir música, brincar com blocos...',
                controller: widget.cadastro.text('atividades_favoritas'),
              ),

              const SizedBox(height: 20),

              // =========================
              // GATILHOS
              // =========================

              const Text(
                'Quais são os principais gatilhos?\n'
                '(situações que podem causar crises ou\n'
                'estresse).',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              TextArea(
                hint: 'Ex.: barulho alto, lugares cheios...',
                maxLines: 4,
                controller: widget.cadastro.text('gatilhos'),
              ),

              const SizedBox(height: 20),

              // =========================
              // O QUE AJUDA A ACALMAR
              // =========================

              const Text(
                'O que ajuda a acalmar?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              FormField(
                hint: 'Ex.: abraço, música, brinquedo favorito...',
                controller: widget.cadastro.text('o_que_acalma'),
              ),

              const SizedBox(height: 20),

              // =========================
              // COMUNICAÇÃO
              // =========================

              const Text(
                'Como a criança se comunica?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              DropdownField(
                hint: 'Selecione ou digite',
                value: comunicacaoSelecionada,
                onTap: selecionarComunicacao,
              ),

              const SizedBox(height: 20),

              // =========================
              // CONTINUAR
              // =========================

              ContinueButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroRotinaPage(
                        cadastro: widget.cadastro,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}