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
  }) : baseUrl = baseUrl ?? 'http://192.168.0.65:8000/api',
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

  Future<UsuarioModel> criarConta({
    required String nomeCompleto,
    required String email,
    required String senha,
  }) async {
    final result = await _post('/auth/register/', {
      'nome_completo': nomeCompleto,
      'email': email,
      'senha': senha,
    });
    await _saveToken(result);
    return UsuarioModel.fromJson(_userJson(result));
  }

  Future<String?> get token => storage.read(key: tokenKey);
  Future<void> logout() => storage.delete(key: tokenKey);

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw Exception('Falha na autenticação (${response.statusCode})');
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<void> _saveToken(Map<String, dynamic> result) async {
    final value = result['access'] ?? result['token'];
    if (value is String && value.isNotEmpty)
      await storage.write(key: tokenKey, value: value);
  }

  Map<String, dynamic> _userJson(Map<String, dynamic> result) =>
      result['usuario'] is Map
      ? Map<String, dynamic>.from(result['usuario'] as Map)
      : result;
}
