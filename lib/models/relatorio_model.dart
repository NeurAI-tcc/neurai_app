class RelatorioModel {
  final Duration tempoMonitorado;
  final int situacoesTranquilas;
  final int alertasRegistrados;
  final int eventos;
  final List<String> insights;
  final String? pdfUrl;

  const RelatorioModel({
    required this.tempoMonitorado,
    required this.situacoesTranquilas,
    required this.alertasRegistrados,
    required this.eventos,
    required this.insights,
    this.pdfUrl,
  });

  factory RelatorioModel.fromJson(Map<String, dynamic> json) => RelatorioModel(
    tempoMonitorado: Duration(
      minutes: (json['tempo_monitorado_minutos'] as num?)?.toInt() ?? 0,
    ),
    situacoesTranquilas: (json['situacoes_tranquilas'] as num?)?.toInt() ?? 0,
    alertasRegistrados: (json['alertas_registrados'] as num?)?.toInt() ?? 0,
    eventos: (json['eventos'] as num?)?.toInt() ?? 0,
    insights: json['insights'] is List
        ? (json['insights'] as List).whereType<String>().toList()
        : const [],
    pdfUrl: json['pdf_url'] as String?,
  );
}
