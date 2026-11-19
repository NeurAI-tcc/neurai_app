import '../models/agenda_model.dart';
import '../models/relatorio_model.dart';
import 'api_service.dart';

class ReportService {
  final ApiService api;
  ReportService({ApiService? api}) : api = api ?? ApiService();

  Future<RelatorioModel> buscarDashboard({
    required String token,
    required String periodo,
  }) async {
    final json = await api.getJson(
      '/relatorios/dashboard/',
      token: token,
      queryParameters: {'periodo': periodo},
    );
    final relatorio = RelatorioModel.fromJson(
      json['relatorio'] is Map
          ? Map<String, dynamic>.from(json['relatorio'] as Map)
          : json,
    );

    final eventos = await _buscarEventosDaSemana(token);
    return relatorio.comEventos(eventos.length, eventos);
  }

  Future<List<EventoModel>> _buscarEventosDaSemana(String token) async {
    final hoje = DateTime.now();
    final primeiroDia = hoje.subtract(
      Duration(days: hoje.weekday - DateTime.monday),
    );
    final inicioSemana = DateTime(
      primeiroDia.year,
      primeiroDia.month,
      primeiroDia.day,
    );
    final fimSemana = inicioSemana.add(const Duration(days: 7));

    final eventos = <EventoModel>[];
    final ids = <String>{};

    try {
      final resposta = await api.getJson(
        '/agenda/eventos/',
        token: token,
      );
      final raw =
          resposta['data'] ?? resposta['eventos'] ?? resposta['results'];
      if (raw is List) {
        for (final item in raw.whereType<Map>()) {
          final evento = EventoModel.fromJson(
            Map<String, dynamic>.from(item),
          );
          if (evento.inicio.isBefore(inicioSemana) ||
              !evento.inicio.isBefore(fimSemana)) {
            continue;
          }
          if (evento.id.isEmpty || ids.add(evento.id)) {
            eventos.add(evento);
          }
        }
      }
    } catch (_) {
      return _buscarEventosPorDia(token, inicioSemana);
    }

    if (eventos.isEmpty) {
      return _buscarEventosPorDia(token, inicioSemana);
    }

    eventos.sort((a, b) => a.inicio.compareTo(b.inicio));
    return eventos;
  }

  Future<List<EventoModel>> _buscarEventosPorDia(
    String token,
    DateTime inicioSemana,
  ) async {
    final respostas = await Future.wait(
      List.generate(7, (indice) {
        final dia = inicioSemana.add(Duration(days: indice));
        final data =
            '${dia.year.toString().padLeft(4, '0')}-'
            '${dia.month.toString().padLeft(2, '0')}-'
            '${dia.day.toString().padLeft(2, '0')}';
        return api.getJson(
          '/agenda/eventos/',
          token: token,
          queryParameters: {'data': data},
        );
      }),
    );

    final eventos = <EventoModel>[];
    final ids = <String>{};

    for (final resposta in respostas) {
      final raw =
          resposta['data'] ?? resposta['eventos'] ?? resposta['results'];
      if (raw is! List) continue;

      for (final item in raw.whereType<Map>()) {
        final evento = EventoModel.fromJson(
          Map<String, dynamic>.from(item),
        );
        if (evento.id.isEmpty || ids.add(evento.id)) {
          eventos.add(evento);
        }
      }
    }

    eventos.sort((a, b) => a.inicio.compareTo(b.inicio));
    return eventos;
  }
}
