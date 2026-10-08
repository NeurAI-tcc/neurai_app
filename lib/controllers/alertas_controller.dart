import 'package:flutter/foundation.dart';
import '../models/alerta_model.dart';
import '../services/alert_service.dart';

enum TipoAlertaFiltro { todos, rotina, saude, medicamentos }

class AlertasController extends ChangeNotifier {
  final AlertService service;
  final List<AlertaModel> alertas = [];
  TipoAlertaFiltro filtro = TipoAlertaFiltro.todos;
  bool carregando = false;
  bool temMais = true;
  String? erro;
  int _pagina = 0;

  AlertasController({AlertService? service})
    : service = service ?? AlertService();

  Map<DateTime, List<AlertaModel>> get alertasAgrupados {
    final agrupados = <DateTime, List<AlertaModel>>{};
    for (final alerta in alertas) {
      final dia = DateTime(
        alerta.timestamp.year,
        alerta.timestamp.month,
        alerta.timestamp.day,
      );
      agrupados.putIfAbsent(dia, () => []).add(alerta);
    }
    return agrupados;
  }

  Future<void> carregar(String token, {bool atualizar = true}) async {
    if (carregando) return;
    carregando = true;
    erro = null;
    if (atualizar) {
      alertas.clear();
      _pagina = 0;
      temMais = true;
    }
    notifyListeners();
    try {
      if (temMais) {
        final pagina = await service.buscarHistorico(
          token: token,
          pagina: _pagina + 1,
          tipo: _tipoApi,
        );
        alertas.addAll(pagina.itens);
        _pagina = pagina.pagina;
        temMais = pagina.temMais;
      }
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> aplicarFiltro(String token, TipoAlertaFiltro novoFiltro) async {
    filtro = novoFiltro;
    await carregar(token);
  }

  String? get _tipoApi => filtro == TipoAlertaFiltro.todos ? null : filtro.name;
}
