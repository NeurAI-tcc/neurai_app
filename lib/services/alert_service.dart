import '../models/alerta_model.dart';
import 'api_service.dart';

class PaginaAlertas {
  final List<AlertaModel> itens;
  final int pagina;
  final bool temMais;
  const PaginaAlertas({
    required this.itens,
    required this.pagina,
    required this.temMais,
  });
}

class AlertService {
  final ApiService api;
  AlertService({ApiService? api}) : api = api ?? ApiService();

  Future<PaginaAlertas> buscarHistorico({
    required String token,
    int pagina = 1,
    int porPagina = 20,
    String? tipo,
  }) async {
    final result = await api.getJson(
      '/alertas/',
      token: token,
      queryParameters: {
        'page': '$pagina',
        'page_size': '$porPagina',
        'tipo': ?tipo,
      },
    );
    final raw = result['results'] ?? result['alertas'] ?? const [];
    final itens = raw is List
        ? raw
              .whereType<Map>()
              .map(
                (item) => AlertaModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <AlertaModel>[];
    return PaginaAlertas(
      itens: itens,
      pagina: pagina,
      temMais: result['next'] != null || (itens.length == porPagina),
    );
  }
}
