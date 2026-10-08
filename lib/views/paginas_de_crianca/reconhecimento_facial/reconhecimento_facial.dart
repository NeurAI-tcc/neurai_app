import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neurai_app/models/cadastro_crianca_draft.dart';
import 'package:neurai_app/views/contents/app_colors.dart';
import 'package:neurai_app/views/contents/child_step_indicador.dart';
import 'package:neurai_app/views/contents/continue_button.dart';
import 'package:neurai_app/views/contents/foto_capture.dart';

import 'reconhecimento_final_page.dart';

class ReconhecimentoFacialPage extends StatefulWidget {
  const ReconhecimentoFacialPage({super.key, required this.cadastro});

  final CadastroCriancaDraft cadastro;

  @override
  State<ReconhecimentoFacialPage> createState() =>
      _ReconhecimentoFacialPageState();
}

class _ReconhecimentoFacialPageState
    extends State<ReconhecimentoFacialPage> {

  // =========================
  // ETAPA ATUAL
  // =========================

  int etapaAtual = 1;

  // =========================
  // FOTOS
  // 7 FOTOS
  // =========================

  final List<XFile?> fotos = List<XFile?>.filled(7, null);

  // =========================
  // INFORMAÇÕES DAS ETAPAS
  // =========================

  final List<Map<String, String>> etapas = [
    {
      'titulo': 'Foto de frente',
      'descricao':
          'Posicione o rosto de frente para a câmera e mantenha uma expressão neutra.',
      'imagem': 'assets/foto_frente.png',
    },
    {
      'titulo': 'Foto do lado direito',
      'descricao':
          'Gire o rosto para o lado direito e mantenha o rosto visível.',
      'imagem': 'assets/foto_direita.png',
    },
    {
      'titulo': 'Foto do lado esquerdo',
      'descricao':
          'Gire o rosto para o lado esquerdo e mantenha o rosto visível.',
      'imagem': 'assets/foto_esquerda.png',
    },
    {
      'titulo': 'Foto de cima',
      'descricao':
          'Incline o rosto levemente para cima e mantenha o rosto visível.',
      'imagem': 'assets/foto_cima.png',
    },
    {
      'titulo': 'Foto de baixo',
      'descricao':
          'Incline o rosto levemente para baixo e mantenha o rosto visível.',
      'imagem': 'assets/foto_baixo.png',
    },
    {
      'titulo': 'Foto sorrindo',
      'descricao':
          'Sorria levemente e mantenha o rosto visível para a câmera.',
      'imagem': 'assets/foto_sorrindo.png',
    },
    {
      'titulo': 'Foto adicional',
      'descricao':
          'Mantenha o rosto visível e siga a orientação apresentada.',
      'imagem': 'assets/foto_frente.png',
    },
  ];

  // =========================
  // FOTO SELECIONADA
  // =========================

  void fotoSelecionada(XFile foto) {
    setState(() {
      fotos[etapaAtual - 1] = foto;
    });
  }

  // =========================
  // CONTINUAR
  // =========================

  void continuar() {
    // Verifica se a foto da etapa atual foi tirada
    if (fotos[etapaAtual - 1] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tire a foto antes de continuar.',
          ),
        ),
      );

      return;
    }

    // Se ainda não chegou na última foto,
    // passa para a próxima etapa
    if (etapaAtual < 7) {
      setState(() {
        etapaAtual++;
      });

      return;
    }

    // Se chegou aqui, as 7 fotos foram tiradas.
    // Abre a tela final.
    widget.cadastro.fotos
      ..clear()
      ..addAll(fotos.whereType<XFile>());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReconhecimentoFinalPage(
          cadastro: widget.cadastro,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final etapa = etapas[etapaAtual - 1];

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
                horizontal: 20,
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

                  ChildStepIndicator(
                    currentStep: etapaAtual,
                    totalSteps: 8,
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // EXPLICAÇÃO
                  // =========================

                  const Text(
                    'Vamos tirar algumas fotos para confirmar a '
                    'identidade para reconhecimento da criança.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // =========================
                  // TÍTULO DA ETAPA
                  // =========================

                  Text(
                    etapa['titulo']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // ILUSTRAÇÃO
                  // =========================

                  Center(
                    child: Image.asset(
                      etapa['imagem']!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // DESCRIÇÃO
                  // =========================

                  Center(
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        etapa['descricao']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // TIRAR FOTO
                  // =========================

                  Center(
                    child: PhotoCapture(
                      onFotoSelecionada: fotoSelecionada,
                    ),
                  ),

                  const Spacer(),

                  // =========================
                  // CONTINUAR
                  // =========================

                  ContinueButton(
                    onPressed: continuar,
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