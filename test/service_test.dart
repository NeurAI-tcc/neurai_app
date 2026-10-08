import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:neurai_app/services/alert_service.dart';
import 'package:neurai_app/services/api_service.dart';
import 'package:neurai_app/services/auth_service.dart';
import 'package:neurai_app/services/report_service.dart';

class TestClient extends http.BaseClient {
  final Future<http.Response> Function(http.BaseRequest request) handler;
  TestClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}

void main() {
  test('ApiService envia token e decodifica resposta', () async {
    late http.BaseRequest request;
    final client = TestClient((current) async {
      request = current;
      return http.Response(jsonEncode({'ok': true}), 200);
    });

    final result = await ApiService(
      baseUrl: 'https://api.test',
      client: client,
    ).getJson('/ping', token: 'jwt-123');

    expect(result['ok'], isTrue);
    expect(request.headers['authorization'], 'Bearer jwt-123');
    expect(request.url.queryParameters, isEmpty);
  });

  test('AlertService mapeia paginação', () async {
    final client = TestClient(
      (request) async => http.Response(
        jsonEncode({
          'results': [
            {
              'id': 'a1',
              'timestamp': '2026-10-01T12:00:00Z',
              'tipo': 'rotina',
              'detalhes': 'Choro',
              'confianca_ia': 0.8,
              'camera_id': 'c1',
            },
          ],
          'next': 'page/2',
        }),
        200,
      ),
    );
    final page = await AlertService(
      api: ApiService(baseUrl: 'https://api.test', client: client),
    ).buscarHistorico(token: 'jwt', pagina: 1);

    expect(page.itens.single.id, 'a1');
    expect(page.temMais, isTrue);
  });

  test('ReportService converte dashboard em relatório', () async {
    final client = TestClient(
      (request) async => http.Response(
        jsonEncode({
          'relatorio': {
            'tempo_monitorado_minutos': 90,
            'situacoes_tranquilas': 4,
            'alertas_registrados': 2,
            'eventos': 3,
            'insights': ['Rotina estável'],
          },
        }),
        200,
      ),
    );
    final report = await ReportService(
      api: ApiService(baseUrl: 'https://api.test', client: client),
    ).buscarDashboard(token: 'jwt', periodo: 'semanal');

    expect(report.tempoMonitorado.inMinutes, 90);
    expect(report.insights, ['Rotina estável']);
  });

  test('AuthService transforma erro HTTP em exceção', () async {
    final client = TestClient(
      (request) async =>
          http.Response(jsonEncode({'detail': 'Credenciais inválidas'}), 401),
    );
    final service = AuthService(baseUrl: 'https://api.test', client: client);

    expect(() => service.login('user@test.com', 'wrong'), throwsException);
  });

  test('AuthService envia cadastro completo para a rota de cadastro', () async {
    late http.BaseRequest sentRequest;
    final client = TestClient((request) async {
      sentRequest = request;
      return http.Response('', 201);
    });
    final service = AuthService(baseUrl: 'https://api.test', client: client);
    final payload = {
      'tipo_usuario': 'Responsavel',
      'nome_completo': 'Responsável',
      'email': 'responsavel@example.com',
      'senha': 'senha-segura',
      'valor': 50.0,
      'perfil_crianca': {
        'nome_completo': 'Criança',
        'foto_sorrindo_url': 'AQID',
      },
    };

    await service.cadastrarCompleto(payload);

    expect(sentRequest.url.path, '/auth/cadastro/');
    expect(sentRequest.method, 'POST');
    expect(sentRequest.headers['content-type'], 'application/json');
    expect(jsonDecode((sentRequest as http.Request).body), payload);
  });
}
