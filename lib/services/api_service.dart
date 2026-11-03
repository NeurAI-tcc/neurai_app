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
            defaultValue: 'http://172.31.173.46/api',
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
