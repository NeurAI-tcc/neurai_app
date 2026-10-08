import 'package:flutter/material.dart';
import 'package:neurai_app/views/contents/app_colors.dart';
import 'package:neurai_app/views/contents/continue_button.dart';


class ReconhecimentoFinalPage extends StatelessWidget {
  const ReconhecimentoFinalPage({
    super.key,
  });

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
              padding: const EdgeInsets.symmetric(
                horizontal: 23,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 15),

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
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // =========================
                  // TÍTULO
                  // =========================

                  const Text(
                    'Reconhecimento facial',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // =========================
                  // INDICADOR
                  // =========================

                  const Row(
                    children: [

                      _Step(number: '1'),
                      _Step(number: '2'),
                      _Step(number: '3'),
                      _Step(number: '4'),
                      _Step(number: '5'),
                      _Step(number: '6'),
                      _Step(number: '7'),
                      _Step(number: '8'),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // EXPLICAÇÃO
                  // =========================


                  const SizedBox(height: 10),

                  // =========================
                  // TÍTULO
                  // =========================

                  const Text(
                    'Confirmação',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Espaço até o ícone
                  const SizedBox(height: 58),

                  // =========================
                  // CÍRCULO DE CONFIRMAÇÃO
                  // =========================

                  Center(
                    child: Container(
                      width: 108,
                      height: 108,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF63D5CA),
                            Color(0xFF6095F4),
                          ],
                        ),
                      ),

                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 68,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // =========================
                  // MENSAGEM
                  // =========================

                  const Center(
                    child: Text(
                      'Fotos registradas com sucesso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Center(
                    child: Text(
                      'A identidade foi confirmada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // =========================
                  // BOTÃO
                  // =========================

                  ContinueButton(
                    onPressed: () {
                      // Próxima tela
                    },
                  ),

                  const SizedBox(height: 30),
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
}


// =====================================================
// INDICADOR DE ETAPAS
// =====================================================

class _Step extends StatelessWidget {
  final String number;

  const _Step({
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
        ),

        child: Center(
          child: Container(
            width: 18,
            height: 18,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6095F4),
            ),

            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}