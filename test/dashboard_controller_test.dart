import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:app_teste_tcc/controllers/dashboard_controller.dart';
import 'package:app_teste_tcc/models/alerta_model.dart';
import 'package:app_teste_tcc/models/camera_frame_model.dart';
import 'package:app_teste_tcc/services/alert_service.dart';
import 'package:app_teste_tcc/services/api_service.dart';
import 'package:app_teste_tcc/services/camera_stream_service.dart';

class DashboardTestClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = jsonEncode({
      'metricas': {
        'minutos_monitorados': 120,
        'alertas_hoje': 1,
        'eventos_hoje': 3,
        'situacoes_tranquilas': 8,
      },
    });
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      200,
      request: request,
    );
  }
}

class DashboardAlertService extends AlertService {
  @override
  Future<PaginaAlertas> buscarHistorico({
    required String token,
    int pagina = 1,
    int porPagina = 20,
    String? tipo,
  }) async {
    return PaginaAlertas(
      itens: [
        AlertaModel(
          id: 'alert-1',
          timestamp: DateTime(2026, 10, 1),
          tipoCrise: 'rotina',
          detalhes: 'Alerta de teste',
          falsoPositivo: false,
          confiancaIa: 0.9,
          cameraId: 'camera-1',
        ),
      ],
      pagina: 1,
      temMais: false,
    );
  }
}

class DashboardCameraService extends CameraStreamService {
  final StreamController<CameraFrame> framesController =
      StreamController.broadcast();

  @override
  Stream<CameraFrame> get frames => framesController.stream;

  @override
  Future<void> connect({
    required String cameraId,
    required String token,
  }) async {}

  @override
  Future<void> dispose() async => framesController.close();
}

void main() {
  test('DashboardController carrega métricas e último alerta', () async {
    final controller = DashboardController(
      api: ApiService(
        baseUrl: 'https://api.test',
        client: DashboardTestClient(),
      ),
      alertService: DashboardAlertService(),
      cameraService: DashboardCameraService(),
    );

    await controller.carregarResumo('jwt');

    expect(controller.erro, isNull);
    expect(controller.metricasDoDia?.minutosMonitorados, 120);
    expect(controller.ultimoAlerta?.id, 'alert-1');
    controller.dispose();
  });
}
