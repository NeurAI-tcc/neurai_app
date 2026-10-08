import 'package:flutter/material.dart' hide FormField;
import 'package:neurai_app/views/contents/continue_button.dart';
import 'package:neurai_app/views/contents/date_field.dart';
import 'package:neurai_app/views/contents/dropdown.dart';
import 'package:neurai_app/views/contents/foto_select.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_diagnostico.dart';

import '../contents/app_colors.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import '../contents/form_field.dart';

class CadastroCriancaPage extends StatefulWidget {
  const CadastroCriancaPage({super.key});

  @override
  State<CadastroCriancaPage> createState() => _CadastroCriancaPageState();
}

class _CadastroCriancaPageState extends State<CadastroCriancaPage> {

  // =========================
  // VARIÁVEIS
  // =========================

  DateTime? dataNascimento;
  String? sexoSelecionado;

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
        dataNascimento = data;
      });
    }
  }

  // =========================
  // SELECIONAR SEXO
  // =========================

  Future<void> selecionarSexo() async {
    final String? sexo = await showModalBottomSheet<String>(
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
                  'Selecione o sexo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Feminino'),
                onTap: () {
                  Navigator.pop(context, 'Feminino');
                },
              ),

              ListTile(
                title: const Text('Masculino'),
                onTap: () {
                  Navigator.pop(context, 'Masculino');
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    if (sexo != null) {
      setState(() {
        sexoSelecionado = sexo;
      });
    }
  }

  // =========================
  // TELA
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Stack(
        children: [

          SafeArea(
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
                    currentStep: 1,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Informações básicas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // FOTO
                  // =========================

                  const PhotoSelect(),

                  const SizedBox(height: 20),

                  // =========================
                  // NOME COMPLETO
                  // =========================

                  const Text(
                    'Nome completo da criança',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const FormField(
                    hint: 'Digite o nome completo',
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // NOME SOCIAL
                  // =========================

                  const Text(
                    'Nome social (opcional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const FormField(
                    hint: 'Como prefere chamar?',
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // DATA DE NASCIMENTO
                  // =========================

                  const Text(
                    'Data de nascimento',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  DateField(
                    hint: 'dd/mm/aaaa',
                    value: dataNascimento,
                    onTap: selecionarData,
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // SEXO
                  // =========================

                  const Text(
                    'Sexo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  DropdownField(
                    hint: 'Selecione',
                    value: sexoSelecionado,
                    onTap: selecionarSexo,
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
                              const CadastroDiagnosticoPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}