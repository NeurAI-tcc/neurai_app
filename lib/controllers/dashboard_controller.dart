import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/alerta_model.dart';
import '../models/camera_frame_model.dart';
import '../models/dashboard_model.dart';
import '../services/alert_service.dart';
import '../services/api_service.dart';
import '../services/camera_stream_service.dart';

class DashboardController extends ChangeNotifier {
  final CameraStreamService cameraService;
  final AlertService alertService;
  final ApiService api;
  StreamSubscription<CameraFrame>? _subscription;
  CameraFrame? frameAtual;
  MetricasDashboard? metricasDoDia;
  AlertaModel? ultimoAlerta;
  bool carregando = false;
  String? erro;

  DashboardController({
    CameraStreamService? cameraService,
    AlertService? alertService,
    ApiService? api,
  }) : cameraService = cameraService ?? CameraStreamService(),
       alertService = alertService ?? AlertService(),
       api = api ?? ApiService() {
    _subscription = this.cameraService.frames.listen((frame) {
      frameAtual = frame;
      notifyListeners();
    });
  }

  Stream<CameraFrame> get cameraStream => cameraService.frames;

  Future<void> iniciarCamera({
    required String cameraId,
    required String token,
  }) => cameraService.connect(cameraId: cameraId, token: token);

  Future<void> carregarResumo(String token) async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      final json = await api.getJson('/dashboard/resumo/', token: token);
      final data = json['metricas'] is Map
          ? Map<String, dynamic>.from(json['metricas'] as Map)
          : json;
      metricasDoDia = MetricasDashboard.fromJson(data);
      final pagina = await alertService.buscarHistorico(
        token: token,
        pagina: 1,
        porPagina: 1,
      );
      ultimoAlerta = pagina.itens.isEmpty ? null : pagina.itens.first;
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    cameraService.dispose();
    super.dispose();
  }
}
