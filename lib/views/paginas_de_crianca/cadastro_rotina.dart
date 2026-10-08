import 'package:flutter/material.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_informacoes.dart';

import '../contents/app_colors.dart';
import '../contents/continue_button.dart';
import '../contents/dropdown.dart';
import '../contents/option.dart';
import '../contents/text_area.dart';
import '../contents/time_field.dart';

class CadastroRotinaPage extends StatefulWidget {
  const CadastroRotinaPage({super.key});

  @override
  State<CadastroRotinaPage> createState() =>
      _CadastroRotinaPageState();
}

class _CadastroRotinaPageState
    extends State<CadastroRotinaPage> {

  TimeOfDay? horarioAcordar;
  TimeOfDay? horarioDormir;

  bool? fazSoneca;
  bool? seletividadeAlimentar;

  String? alimentacaoSelecionada;

  // =========================
  // SELECIONAR HORÁRIO
  // =========================

  Future<void> selecionarHorarioAcordar() async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        horarioAcordar = horario;
      });
    }
  }

  Future<void> selecionarHorarioDormir() async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        horarioDormir = horario;
      });
    }
  }

  // =========================
  // ALIMENTAÇÃO
  // =========================

  Future<void> selecionarAlimentacao() async {
    final String? resultado =
        await showModalBottomSheet<String>(
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
                  'Alimentação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Alimentação comum'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Alimentação comum',
                  );
                },
              ),

              ListTile(
                title: const Text('Alimentação especial'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Alimentação especial',
                  );
                },
              ),

              ListTile(
                title: const Text('Dieta específica'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Dieta específica',
                  );
                },
              ),

              ListTile(
                title: const Text('Outra'),
                onTap: () {
                  Navigator.pop(
                    context,
                    'Outra',
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );

    if (resultado != null) {
      setState(() {
        alimentacaoSelecionada = resultado;
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
            horizontal: 18,
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
                    fit: BoxFit.contain,
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
                currentStep: 5,
              ),

              const SizedBox(height: 18),

              // =========================
              // TÍTULO
              // =========================

              const Text(
                'Rotina diária',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Isso nos ajuda a entender os melhores\n'
                'momentos para monitorar e alertar.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // ACORDAR
              // =========================

              const Text(
                'Horário de acordar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              TimeField(
                hint: 'hh:mm',
                value: horarioAcordar,
                onTap: selecionarHorarioAcordar,
              ),

              const SizedBox(height: 20),

              // =========================
              // DORMIR
              // =========================

              const Text(
                'Horário de dormir',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              TimeField(
                hint: 'hh:mm',
                value: horarioDormir,
                onTap: selecionarHorarioDormir,
              ),

              const SizedBox(height: 20),

              // =========================
              // SONECAS
              // =========================

              const Text(
                'Sonecas durante o dia?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [

                  Option(
                    text: 'Sim',
                    selected: fazSoneca == true,
                    onTap: () {
                      setState(() {
                        fazSoneca = true;
                      });
                    },
                  ),

                  Option(
                    text: 'Não',
                    selected: fazSoneca == false,
                    onTap: () {
                      setState(() {
                        fazSoneca = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // ALIMENTAÇÃO
              // =========================

              const Text(
                'Alimentação',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              DropdownField(
                hint: 'Selecione',
                value: alimentacaoSelecionada,
                onTap: selecionarAlimentacao,
              ),

              const SizedBox(height: 20),

              // =========================
              // SELETIVIDADE
              // =========================

              const Text(
                'Possui seletividade alimentar?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [

                  Option(
                    text: 'Sim',
                    selected:
                        seletividadeAlimentar == true,
                    onTap: () {
                      setState(() {
                        seletividadeAlimentar = true;
                      });
                    },
                  ),

                  Option(
                    text: 'Não',
                    selected:
                        seletividadeAlimentar == false,
                    onTap: () {
                      setState(() {
                        seletividadeAlimentar = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // ATIVIDADES
              // =========================

              const Text(
                'Atividades terapêuticas ou escolares?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 6),

              const TextArea(
                hint:
                    'Ex.: terapia ocupacional, fonoaudiologia,\n'
                    'escola integral...',
                maxLines: 3,
              ),

              const SizedBox(height: 40),

              // =========================
              // CONTINUAR
              // =========================

              ContinueButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CadastroInformacoesPage(),
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