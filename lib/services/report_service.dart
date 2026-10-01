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
    return RelatorioModel.fromJson(
      json['relatorio'] is Map
          ? Map<String, dynamic>.from(json['relatorio'] as Map)
          : json,
    );
  }
}
