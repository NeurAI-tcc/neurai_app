import 'package:flutter/material.dart';
import 'package:neurai_app/models/cadastro_crianca_draft.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import 'package:neurai_app/views/paginas_de_crianca/reconhecimento_facial/reconhecimento_facial.dart';

import '../contents/app_colors.dart';
import '../contents/continue_button.dart';
import '../contents/text_area.dart';

class CadastroInformacoesPage extends StatelessWidget {
  const CadastroInformacoesPage({super.key, required this.cadastro});

  final CadastroCriancaDraft cadastro;

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
                currentStep: 6,
              ),

              const SizedBox(height: 18),

              // =========================
              // TÍTULO
              // =========================

              const Text(
                'Informações adicionais',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Quase - lá! Essas informações finais ajudam a\n'
                'oferecer um cuidado ainda melhor.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // INFORMAÇÕES IMPORTANTES
              // =========================

              const Text(
                'Alguma informação importante que\n'
                'devemos saber?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 6),

              TextArea(
                hint:
                    'Ex.: comportamentos específicos,\n'
                    'preferências, observações...',
                maxLines: 4,
                controller: cadastro.text('observacoes'),
              ),

              const SizedBox(height: 20),

              // =========================
              // RESUMO
              // =========================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFB8C8D5),
                  ),
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.green,
                      size: 22,
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            'Você está quase concluindo o\n'
                            'cadastro.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Informações básicas\n'
                            'Diagnóstico\n'
                            'Saúde\n'
                            'Preferências\n'
                            'Rotina\n'
                            'Informações adicionais',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: Color(0xFF444444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // FINALIZAR
              // =========================

              ContinueButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReconhecimentoFacialPage(
                        cadastro: cadastro,
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