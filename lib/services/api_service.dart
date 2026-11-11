import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/camera_model.dart';
import '../models/usuario_model.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({String? baseUrl, http.Client? client})
    : baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'NEURAI_API_URL',
            defaultValue: 'http://192.168.15.17:8000/api',
          ),
      client = client ?? http.Client();

  Future<UsuarioModel> buscarDadosUsuario(String usuarioId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/usuario/$usuarioId/'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao obter dados do usuário');
    }
    return UsuarioModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<CameraModel> buscarCamera({required String token}) async {
    final json = await getJson('/camera/', token: token);
    final data = json['camera'] is Map
        ? Map<String, dynamic>.from(json['camera'] as Map)
        : json;
    return CameraModel.fromJson(data);
  }

  Future<UsuarioModel> buscarPerfil({required String token}) async {
    final json = await getJson('/perfil/', token: token);
    final data = _unwrapPerfil(json);
    return UsuarioModel.fromJson(data);
  }

  Map<String, dynamic> _unwrapPerfil(Map<String, dynamic> json) {
    for (final chave in const ['usuario', 'user', 'resultado', 'data']) {
      final valor = json[chave];
      if (valor is Map) {
        return _unwrapPerfil(Map<String, dynamic>.from(valor));
      }
    }
    return _perfilData(json);
  }

  Map<String, dynamic> _perfilData(Map<String, dynamic> json) {
    final perfil = json['perfil'];
    if (perfil is! Map) return json;

    final perfilMap = Map<String, dynamic>.from(perfil);
    if (perfilMap.containsKey('email') ||
        perfilMap.containsKey('nome_completo') ||
        perfilMap.containsKey('perfil_crianca')) {
      return perfilMap;
    }

    return {...json, 'perfil_crianca': perfilMap}..remove('perfil');
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$path',
    ).replace(queryParameters: queryParameters);
    final response = await client.get(uri, headers: _headers(token));
    return _decode(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Map<String, String> _headers(String? token) => {
    'Content-Type': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha na API (${response.statusCode})');
    }
    return decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : {'data': decoded};
  }
}
