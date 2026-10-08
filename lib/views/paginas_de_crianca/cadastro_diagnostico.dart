import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_saude.dart';

import '../contents/app_colors.dart';
import '../contents/continue_button.dart';
import '../contents/date_field.dart';
import '../contents/dropdown.dart';
import '../contents/file_picker.dart';

class CadastroDiagnosticoPage extends StatefulWidget {
  const CadastroDiagnosticoPage({super.key});

  @override
  State<CadastroDiagnosticoPage> createState() =>
      _CadastroDiagnosticoPageState();
}

class _CadastroDiagnosticoPageState
    extends State<CadastroDiagnosticoPage> {

  // =========================
  // VARIÁVEIS
  // =========================

  DateTime? dataDiagnostico;

  String? diagnosticoSelecionado;
  String? nivelSuporteSelecionado;

  String? nomeArquivo;

  // =========================
  // SELECIONAR DATA
  // =========================

  Future<void> selecionarData() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        dataDiagnostico = data;
      });
    }
  }

  // =========================
  // SELECIONAR DIAGNÓSTICO
  // =========================

  Future<void> selecionarDiagnostico() async {
    final String? diagnostico = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Selecione o diagnóstico',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Autismo'),
                onTap: () {
                  Navigator.pop(context, 'Autismo');
                },
              ),

              ListTile(
                title: const Text('TDAH'),
                onTap: () {
                  Navigator.pop(context, 'TDAH');
                },
              ),

              ListTile(
                title: const Text('Síndrome de Down'),
                onTap: () {
                  Navigator.pop(context, 'Síndrome de Down');
                },
              ),

              ListTile(
                title: const Text('Deficiência Intelectual'),
                onTap: () {
                  Navigator.pop(context, 'Deficiência Intelectual');
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    if (diagnostico != null) {
      setState(() {
        diagnosticoSelecionado = diagnostico;
      });
    }
  }

  // =========================
  // SELECIONAR NÍVEL
  // =========================

  Future<void> selecionarNivelSuporte() async {
    final String? nivel = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Selecione o nível de suporte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Nível 1'),
                onTap: () {
                  Navigator.pop(context, 'Nível 1');
                },
              ),

              ListTile(
                title: const Text('Nível 2'),
                onTap: () {
                  Navigator.pop(context, 'Nível 2');
                },
              ),

              ListTile(
                title: const Text('Nível 3'),
                onTap: () {
                  Navigator.pop(context, 'Nível 3');
                },
              ),

              ListTile(
                title: const Text('Não possui'),
                onTap: () {
                  Navigator.pop(context, 'Não possui');
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    if (nivel != null) {
      setState(() {
        nivelSuporteSelecionado = nivel;
      });
    }
  }

  // =========================
  // SELECIONAR LAUDO
  // =========================

  Future<void> selecionarArquivo() async {
    try {
      final FilePickerResult? resultado =
        await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

      if (resultado != null) {
        setState(() {
          nomeArquivo = resultado.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar arquivo: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível selecionar o arquivo.',
          ),
        ),
      );
    }
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
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
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // =========================
              // TÍTULO
              // =========================

              const Text(
                'Cadastro da criança',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                'Vamos conhecer melhor para cuidar\n'
                'com mais precisão',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              // =========================
              // ETAPAS
              // =========================

              const ChildStepIndicator(
                currentStep: 2,
              ),

              const SizedBox(height: 18),

              // =========================
              // TÍTULO DA ETAPA
              // =========================

              const Text(
                'Sobre o diagnóstico',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Essas informações nos ajudam a personalizar\n'
                'o monitoramento e os alertas.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // DIAGNÓSTICO
              // =========================

              const Text(
                'Diagnóstico principal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 4),

              DropdownField(
                hint: 'Selecione o diagnóstico',
                value: diagnosticoSelecionado,
                onTap: selecionarDiagnostico,
              ),

              const SizedBox(height: 12),

              // =========================
              // NÍVEL DE SUPORTE
              // =========================

              const Text(
                'Nível de suporte (opcional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 4),

              DropdownField(
                hint: 'Selecione o nível',
                value: nivelSuporteSelecionado,
                onTap: selecionarNivelSuporte,
              ),

              const SizedBox(height: 12),

              // =========================
              // DATA DO DIAGNÓSTICO
              // =========================

              const Text(
                'Quando recebeu o diagnóstico?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 4),

              DateField(
                hint: 'dd/mm/aaaa',
                value: dataDiagnostico,
                onTap: selecionarData,
              ),

              const SizedBox(height: 12),

              // =========================
              // LAUDOS
              // =========================

              const Text(
                'Possui laudos ou relatórios?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              FilePickerButton(
                text: 'Inserir Laudo',
                fileName: nomeArquivo,
                onPressed: selecionarArquivo,
              ),

              const SizedBox(height: 30),

              // =========================
              // CONTINUAR
              // =========================

              ContinueButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CadastroSaudePage(),
                        ),
                      );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}