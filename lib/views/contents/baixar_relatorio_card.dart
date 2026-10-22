
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BaixarRelatorioCard extends StatelessWidget {
  const BaixarRelatorioCard({super.key});

  Future<void> _baixarRelatorio(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Relatorio da Semana',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text('Periodo: 07 a 13 de setembro de 2026'),

              pw.SizedBox(height: 20),

              pw.Header(
                level: 1,
                child: pw.Text('Resumo da semana'),
              ),

              pw.Bullet(
                text: 'Tempo registrado: 2h40m',
              ),
              pw.Bullet(
                text: 'Alertas registrados: 2',
              ),
              pw.Bullet(
                text: 'Eventos registrados: 5',
              ),

              pw.SizedBox(height: 20),

              pw.Header(
                level: 1,
                child: pw.Text('Eventos registrados'),
              ),

              pw.Bullet(
                text: 'Sessao de terapia - 10/05/2026 as 14:00',
              ),
              pw.Bullet(
                text: 'Passeio no parque - 12/05/2026 as 16:30',
              ),
              pw.Bullet(
                text: 'Aula de musica - 13/05/2026 as 10:00',
              ),

              pw.SizedBox(height: 20),

              pw.Header(
                level: 1,
                child: pw.Text('Principais insights da semana'),
              ),

              pw.Paragraph(
                text:
                    'Ariana ficou a maior parte do tempo em situacoes tranquilas.',
              ),

              pw.Paragraph(
                text:
                    'Houve 2 alertas severos. Fique atento aos horarios de maior agitacao.',
              ),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.Text(
                'Relatorio gerado pelo aplicativo NeurAI.',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();

      // Abre a interface para salvar ou imprimir o PDF.
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'relatorio_semana.pdf',
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar o PDF: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF78B9FF),
        ),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: Color(0xFF4789EA),
            size: 25,
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baixar relatório completo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Gere o relatório com todos os dados das análises '
                  'e recomendações da IA em PDF.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Color(0xFF58636D),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          OutlinedButton.icon(
            onPressed: () => _baixarRelatorio(context),
            icon: const Icon(
              Icons.download,
              size: 13,
            ),
            label: const Text(
              'Baixar PDF',
              style: TextStyle(fontSize: 8),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4789EA),
              side: const BorderSide(
                color: Color(0xFF78B9FF),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 9,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
