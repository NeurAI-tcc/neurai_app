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

    final dias = List.generate(7, (indice) {
      final dia = primeiroDia.add(Duration(days: indice));
      final data =
          '${dia.year.toString().padLeft(4, '0')}-'
          '${dia.month.toString().padLeft(2, '0')}-'
          '${dia.day.toString().padLeft(2, '0')}';

      return api.getJson(
        '/agenda/eventos/',
        token: token,
        queryParameters: {'data': data},
      );
    });

    final respostas = await Future.wait(dias);
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

    return eventos;
  }
}
