import 'package:flutter/material.dart';
import 'package:neurai_app/models/cadastro_crianca_draft.dart';
import 'package:neurai_app/views/paginas_de_crianca/cadastro_comportamental.dart';

import '../contents/app_colors.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import '../contents/continue_button.dart';
import '../contents/dropdown.dart';
import '../contents/multi_select_field.dart';
import '../contents/option.dart';
import '../contents/text_area.dart';

class CadastroSaudePage extends StatefulWidget {
  const CadastroSaudePage({super.key, required this.cadastro});

  final CadastroCriancaDraft cadastro;

  @override
  State<CadastroSaudePage> createState() => _CadastroSaudePageState();
}

class _CadastroSaudePageState extends State<CadastroSaudePage> {

  // =========================
  // CONDIÇÕES DE SAÚDE
  // =========================

  List<String> condicoesSelecionadas = [
    'Epilepsia',
    'TDAH',
  ];

  // =========================
  // ALERGIAS
  // =========================

  List<String> alergiasSelecionadas = [];

  // =========================
  // OUTRAS INFORMAÇÕES
  // =========================

  bool? usaMedicacao;
  bool? possuiCrises;

  String? frequenciaSelecionada;

  @override
  void initState() {
    super.initState();
    final conditions = widget.cadastro.valores['condicoes_saude'];
    if (conditions is List<String>) {
      condicoesSelecionadas = [...conditions];
    }
    final allergies = widget.cadastro.valores['alergias'];
    if (allergies is List<String>) {
      alergiasSelecionadas = [...allergies];
    }
    usaMedicacao = widget.cadastro.valores['usa_medicacao'] as bool?;
    possuiCrises = widget.cadastro.valores['possui_crises'] as bool?;
    frequenciaSelecionada =
        widget.cadastro.valores['frequencia_crises'] as String?;
  }

  // =========================
  // SELECIONAR CONDIÇÕES
  // =========================

  Future<void> selecionarCondicoes() async {
    final List<String> opcoes = [
      'Epilepsia',
      'TDAH',
      'Ansiedade',
      'Deficiência intelectual',
      'Outra',
    ];

    List<String> selecionadas = [
      ...condicoesSelecionadas,
    ];

    final resultado = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Condições de saúde',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ...opcoes.map(
                      (opcao) {
                        return CheckboxListTile(
                          title: Text(opcao),
                          value: selecionadas.contains(opcao),
                          activeColor: const Color(0xFF5796E8),
                          onChanged: (valor) {
                            setModalState(() {

                              if (valor == true) {
                                if (!selecionadas.contains(opcao)) {
                                  selecionadas.add(opcao);
                                }
                              } else {
                                selecionadas.remove(opcao);
                              }

                            });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          selecionadas,
                        );
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        condicoesSelecionadas = resultado;
        widget.cadastro.setValue('condicoes_saude', resultado);
      });
    }
  }

  // =========================
  // SELECIONAR ALERGIAS
  // =========================

  Future<void> selecionarAlergias() async {
    final List<String> opcoes = [
      'Nenhuma',
      'Alimentar',
      'Medicamentos',
      'Látex',
      'Poeira',
      'Pólen',
      'Outra',
    ];

    List<String> selecionadas = [
      ...alergiasSelecionadas,
    ];

    final resultado = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Alergias conhecidas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ...opcoes.map(
                      (opcao) {
                        return CheckboxListTile(
                          title: Text(opcao),
                          value: selecionadas.contains(opcao),
                          activeColor: const Color(0xFF5796E8),
                          onChanged: (valor) {
                            setModalState(() {

                              if (opcao == 'Nenhuma') {
                                if (valor == true) {
                                  selecionadas.clear();
                                  selecionadas.add('Nenhuma');
                                } else {
                                  selecionadas.remove('Nenhuma');
                                }
                              } else {
                                if (valor == true) {
                                  selecionadas.remove('Nenhuma');

                                  if (!selecionadas.contains(opcao)) {
                                    selecionadas.add(opcao);
                                  }
                                } else {
                                  selecionadas.remove(opcao);
                                }
                              }

                            });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          selecionadas,
                        );
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        alergiasSelecionadas = resultado;
        widget.cadastro.setValue('alergias', resultado);
      });
    }
  }

  // =========================
  // FREQUÊNCIA DAS CRISES
  // =========================

  Future<void> selecionarFrequencia() async {
    final List<String> opcoes = [
      'Raramente',
      'Mensalmente',
      'Semanalmente',
      'Diariamente',
      'Mais de uma vez por dia',
    ];

    final resultado = await showModalBottomSheet<String>(
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
                  'Com que frequência?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ...opcoes.map(
                (opcao) {
                  return ListTile(
                    title: Text(opcao),
                    onTap: () {
                      Navigator.pop(
                        context,
                        opcao,
                      );
                    },
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
        frequenciaSelecionada = resultado;
        widget.cadastro.setValue('frequencia_crises', resultado);
      });
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
            horizontal: 17,
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

              // =========================
              // ETAPAS
              // =========================

              const ChildStepIndicator(
                currentStep: 3,
              ),

              const SizedBox(height: 18),

              // =========================
              // TÍTULO
              // =========================

              const Text(
                'Sobre a saúde',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Condições de saúde associadas (selecione\n'
                'todas que se aplicam)',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // CONDIÇÕES
              // =========================

              MultiSelectField(
                selectedItems: condicoesSelecionadas,
                onTap: selecionarCondicoes,
              ),

              const SizedBox(height: 20),

              // =========================
              // ALERGIAS
              // =========================

              const Text(
                'Alergias conhecidas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              MultiSelectField(
                selectedItems: alergiasSelecionadas,
                onTap: selecionarAlergias,
              ),

              const SizedBox(height: 20),

              // =========================
              // MEDICAÇÃO
              // =========================

              const Text(
                'Uso de medicações?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Option(
                    text: 'Sim',
                    selected: usaMedicacao == true,
                    onTap: () {
                      setState(() {
                        usaMedicacao = true;
                        widget.cadastro.setValue('usa_medicacao', true);
                      });
                    },
                  ),

                  Option(
                    text: 'Não',
                    selected: usaMedicacao == false,
                    onTap: () {
                      setState(() {
                        usaMedicacao = false;
                        widget.cadastro.setValue('usa_medicacao', false);
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // =========================
              // MEDICAÇÕES
              // =========================

              const Text(
                'Quais medicações e horários?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 6),

              TextArea(
                hint: 'Ex. Ritalina 10mg - 08h e 14h',
                maxLines: 3,
                controller: widget.cadastro.text('medicamentos'),
              ),

              const SizedBox(height: 20),

              // =========================
              // CRISES
              // =========================

              const Text(
                'Possui crises epilépticas?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Option(
                    text: 'Sim',
                    selected: possuiCrises == true,
                    onTap: () {
                      setState(() {
                        possuiCrises = true;
                        widget.cadastro.setValue('possui_crises', true);
                      });
                    },
                  ),

                  Option(
                    text: 'Não',
                    selected: possuiCrises == false,
                    onTap: () {
                      setState(() {
                        possuiCrises = false;
                        widget.cadastro.setValue('possui_crises', false);
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // =========================
              // FREQUÊNCIA
              // =========================

              const Text(
                'Com que frequência?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 5),

              DropdownField(
                hint: 'Selecione',
                value: frequenciaSelecionada,
                onTap: selecionarFrequencia,
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
                          builder: (context) => CadastroComportamentoPage(
                            cadastro: widget.cadastro,
                          ),
                        ),
                      );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}