import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:neurai_app/controllers/agenda_controller.dart';
import 'package:neurai_app/services/api_service.dart';

class AgendaTestClient extends http.BaseClient {
  late Uri requestedUri;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    final body = jsonEncode({
      'eventos': [
        {
          'id': 'event-1',
          'titulo': 'Terapia',
          'inicio': '2026-10-01T09:00:00',
          'fim': '2026-10-01T10:00:00',
          'localizacao': 'Clínica',
        },
      ],
    });
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      200,
      request: request,
    );
  }
}

void main() {
  test('AgendaController busca eventos do dia selecionado', () async {
    final client = AgendaTestClient();
    final controller = AgendaController(
      api: ApiService(baseUrl: 'https://api.test', client: client),
    );

    await controller.carregarEventos('jwt', dia: DateTime(2026, 10, 1));

    expect(controller.erro, isNull);
    expect(controller.eventos.single.titulo, 'Terapia');
    expect(client.requestedUri.queryParameters['data'], '2026-10-01');
  });
}
