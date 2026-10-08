import 'package:flutter_test/flutter_test.dart';
import 'package:neurai_app/controllers/alertas_controller.dart';
import 'package:neurai_app/models/alerta_model.dart';
import 'package:neurai_app/services/alert_service.dart';

class FakeAlertService extends AlertService {
  FakeAlertService(this.pages);
  final List<PaginaAlertas> pages;
  int calls = 0;

  @override
  Future<PaginaAlertas> buscarHistorico({
    required String token,
    int pagina = 1,
    int porPagina = 20,
    String? tipo,
  }) async {
    final response = pages[calls];
    calls++;
    return response;
  }
}

AlertaModel alerta(String id, String timestamp) => AlertaModel(
  id: id,
  timestamp: DateTime.parse(timestamp),
  tipoCrise: 'rotina',
  detalhes: 'teste',
  falsoPositivo: false,
  confiancaIa: 0.8,
  cameraId: 'camera-1',
);

void main() {
  test('AlertasController agrupa alertas pelo dia', () async {
    final fake = FakeAlertService([
      PaginaAlertas(
        itens: [
          alerta('1', '2026-10-01T09:00:00'),
          alerta('2', '2026-10-01T15:00:00'),
          alerta('3', '2026-10-02T09:00:00'),
        ],
        pagina: 1,
        temMais: false,
      ),
    ]);
    final controller = AlertasController(service: fake);

    await controller.carregar('jwt');

    expect(controller.erro, isNull);
    expect(controller.alertasAgrupados, hasLength(2));
    expect(controller.alertasAgrupados[DateTime(2026, 10, 1)], hasLength(2));
    expect(fake.calls, 1);
  });

  test('aplicarFiltro reinicia a paginação e atualiza o filtro', () async {
    final fake = FakeAlertService([
      PaginaAlertas(
        itens: [alerta('1', '2026-10-01T09:00:00')],
        pagina: 1,
        temMais: false,
      ),
      PaginaAlertas(
        itens: [alerta('2', '2026-10-02T09:00:00')],
        pagina: 1,
        temMais: false,
      ),
    ]);
    final controller = AlertasController(service: fake);

    await controller.carregar('jwt');
    await controller.aplicarFiltro('jwt', TipoAlertaFiltro.saude);

    expect(controller.filtro, TipoAlertaFiltro.saude);
    expect(controller.alertas.single.id, '2');
    expect(fake.calls, 2);
  });
}
