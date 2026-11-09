import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/usuario_model.dart';

class AuthService {
  final String baseUrl;
  final http.Client client;
  final FlutterSecureStorage storage;
  static const tokenKey = 'neurai_jwt';

  AuthService({
    String? baseUrl,
    http.Client? client,
    FlutterSecureStorage? storage,
  }) : baseUrl =
           baseUrl ??
           const String.fromEnvironment(
             'NEURAI_API_URL',
             defaultValue: 'http://192.168.15.4:8000/api',
           ),
       client = client ?? http.Client(),
       storage = storage ?? const FlutterSecureStorage();

  Future<UsuarioModel> login(String email, String senha) async {
    final result = await _post('/auth/login/', {
      'email': email,
      'senha': senha,
    });
    await _saveToken(result);
    return UsuarioModel.fromJson(_userJson(result));
  }

  Future<void> solicitarRedefinicaoSenha(String email) async {
    await _post('/auth/password-reset/request/', {'email': email.trim()});
  }

  Future<void> verificarCodigoRedefinicao(String email, String codigo) async {
    await _post('/auth/password-reset/verify/', {
      'email': email.trim(),
      'codigo': codigo.trim(),
    });
  }

  Future<void> confirmarRedefinicaoSenha({
    required String email,
    required String codigo,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    await _post('/auth/password-reset/confirm/', {
      'email': email.trim(),
      'codigo': codigo.trim(),
      'nova_senha': novaSenha,
      'confirmar_senha': confirmarSenha,
    });
  }

  Future<void> cadastrarCompleto(Map<String, dynamic> cadastro) async {
    final dados = Map<String, dynamic>.from(cadastro);
    final cameraRaw = dados.remove('camera');
    final camera = cameraRaw is Map
        ? Map<String, dynamic>.from(cameraRaw)
        : null;
    if (cameraRaw != null && camera == null) {
      throw const FormatException('Os dados da câmera são inválidos.');
    }
    if (camera != null) {
      final ip = camera['endereco_ip'];
      if (ip is! String || ip.trim().isEmpty) {
        throw const FormatException('O endereço IP da câmera é obrigatório.');
      }
      dados['ip_camera'] = ip.trim();
    }

    final cadastroResponse = await client.post(
      Uri.parse('$baseUrl/auth/cadastro/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dados),
    );
    if (cadastroResponse.statusCode < 200 ||
        cadastroResponse.statusCode >= 300) {
      throw Exception(
        'Falha ao cadastrar (${cadastroResponse.statusCode}): ${cadastroResponse.body}',
      );
    }

    if (camera == null) return;
    final loginResult = await _post('/auth/login/', {
      'email': dados['email'],
      'senha': dados['senha'],
    });
    final token = await _saveToken(loginResult);
    final responseCamera = await client.post(
      Uri.parse('$baseUrl/camera/'),
      headers: _headers(token),
      body: jsonEncode({
        'endereco_ip': (camera['endereco_ip'] as String).trim(),
        'nome_camara': camera['nome_camara'] ?? camera['nome'],
        'localizacao': camera['localizacao'],
        'modelo': camera['modelo'],
      }),
    );
    if (responseCamera.statusCode < 200 || responseCamera.statusCode >= 300) {
      throw Exception(
        'Falha ao salvar a câmera (${responseCamera.statusCode}): ${responseCamera.body}',
      );
    }
  }

  Future<String?> get token => storage.read(key: tokenKey);
  Future<void> logout() => storage.delete(key: tokenKey);

  Future<Map<String, dynamic>> getPerfil() => getDadosApi('/perfil/');

  Future<List<dynamic>> getAlertas() async {
    final dados = await getDadosApi('/alertas/');
    final lista = dados['results'] ?? dados['resultados'] ?? dados['alertas'];
    return lista is List ? lista : const [];
  }

  Future<Map<String, dynamic>> getCamera() => getDadosApi('/camera/');

  Future<Map<String, dynamic>> getDadosApi(String caminho) async {
    final chave = await token;
    if (chave == null || chave.isEmpty) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }
    final response = await client.get(
      Uri.parse('$baseUrl$caminho'),
      headers: _headers(chave),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ao consultar $caminho: ${response.statusCode}');
    }
    final dados = jsonDecode(response.body);
    if (dados is! Map) throw const FormatException('Resposta inválida da API.');
    return Map<String, dynamic>.from(dados);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Falha na autenticação (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const FormatException('A resposta da API não é um objeto JSON.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Future<String> _saveToken(Map<String, dynamic> result) async {
    final value = result['access'] ?? result['token'];
    if (value is! String || value.isEmpty) {
      throw const FormatException(
        'A API não retornou um token de autenticação.',
      );
    }
    await storage.write(key: tokenKey, value: value);
    return value;
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _userJson(Map<String, dynamic> result) =>
      result['usuario'] is Map
      ? Map<String, dynamic>.from(result['usuario'] as Map)
      : result;
}
