import 'package:flutter/foundation.dart';
import '../models/agenda_model.dart';
import '../services/api_service.dart';

class AgendaController extends ChangeNotifier {
  final ApiService api;
  DateTime diaSelecionado;
  List<EventoModel> eventos = [];
  bool carregando = false;
  String? erro;

  AgendaController({ApiService? api, DateTime? diaInicial})
    : api = api ?? ApiService(),
      diaSelecionado = diaInicial ?? DateTime.now();

  Future<void> carregarEventos(String token, {DateTime? dia}) async {
    if (dia != null) diaSelecionado = dia;
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      final data = await api.getJson(
        '/agenda/eventos/',
        token: token,
        queryParameters: {'data': _dataIso},
      );
      final raw = data['eventos'] ?? data['results'] ?? const [];
      eventos = raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) =>
                      EventoModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : [];
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  String get _dataIso =>
      '${diaSelecionado.year.toString().padLeft(4, '0')}-${diaSelecionado.month.toString().padLeft(2, '0')}-${diaSelecionado.day.toString().padLeft(2, '0')}';
}
