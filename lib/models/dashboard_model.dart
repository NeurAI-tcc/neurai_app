class MetricasDashboard {
  final int minutosMonitorados;
  final int alertasHoje;
  final int eventosHoje;
  final int situacoesTranquilas;

  const MetricasDashboard({
    required this.minutosMonitorados,
    required this.alertasHoje,
    required this.eventosHoje,
    required this.situacoesTranquilas,
  });

  factory MetricasDashboard.fromJson(Map<String, dynamic> json) =>
      MetricasDashboard(
        minutosMonitorados: (json['minutos_monitorados'] as num?)?.toInt() ?? 0,
        alertasHoje: (json['alertas_hoje'] as num?)?.toInt() ?? 0,
        eventosHoje: (json['eventos_hoje'] as num?)?.toInt() ?? 0,
        situacoesTranquilas:
            (json['situacoes_tranquilas'] as num?)?.toInt() ?? 0,
      );
}
