import 'agenda_model.dart';

class RelatorioModel {
  final Duration tempoMonitorado;
  final int situacoesTranquilas;
  final int alertasRegistrados;
  final int eventos;
  final List<String> insights;
  final List<EventoModel> eventosDetalhados;
  final String? pdfUrl;

  const RelatorioModel({
    required this.tempoMonitorado,
    required this.situacoesTranquilas,
    required this.alertasRegistrados,
    required this.eventos,
    required this.insights,
    this.eventosDetalhados = const [],
    this.pdfUrl,
  });

  factory RelatorioModel.fromJson(Map<String, dynamic> json) => RelatorioModel(
    tempoMonitorado: Duration(
      minutes: (json['tempo_monitorado_minutos'] as num?)?.toInt() ?? 0,
    ),
    situacoesTranquilas: (json['situacoes_tranquilas'] as num?)?.toInt() ?? 0,
    alertasRegistrados: (json['alertas_registrados'] as num?)?.toInt() ?? 0,
    eventos: _quantidadeEventos(json),
    insights: json['insights'] is List
        ? (json['insights'] as List).whereType<String>().toList()
        : const [],
    eventosDetalhados: _eventos(json),
    pdfUrl: json['pdf_url'] as String?,
  );
}

int _quantidadeEventos(Map<String, dynamic> json) {
  final valor = json['eventos'];
  if (valor is num) return valor.toInt();
  if (valor is List) return valor.length;
  return _eventos(json).length;
}

List<EventoModel> _eventos(Map<String, dynamic> json) {
  final raw =
      json['eventos_detalhes'] ??
      json['eventos_registrados'] ??
      json['lista_eventos'] ??
      (json['eventos'] is List ? json['eventos'] : null);
  return raw is List
      ? raw
            .whereType<Map>()
            .map(
              (item) => EventoModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
      : const [];
}
