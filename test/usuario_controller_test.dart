import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:neurai_app/controllers/usuario_controller.dart';
import 'package:neurai_app/services/api_service.dart';

class UsuarioTestClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = jsonEncode({
      'id': 'user-1',
      'nome_completo': 'Responsável',
      'email': 'responsavel@test.com',
      'perfil_crianca': {
        'info_basica': {'nome_completo': 'Criança'},
      },
    });
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
      request: request,
    );
  }
}

void main() {
  test('UsuarioController carrega e disponibiliza o perfil em cache', () async {
    final controller = UsuarioController(
      apiService: ApiService(
        baseUrl: 'https://api.test',
        client: UsuarioTestClient(),
      ),
    );

    await controller.carregarPerfilCompleto('user-1');

    expect(controller.erro, isNull);
    expect(controller.autenticado, isTrue);
    expect(controller.usuarioAtual?.email, 'responsavel@test.com');
    expect(controller.usuarioAtual?.perfilCrianca?.nomeCompleto, 'Criança');
    expect(controller.carregando, isFalse);
  });
}
