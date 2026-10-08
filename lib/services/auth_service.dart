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
             defaultValue: 'http://192.168.0.65:8000/api',
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

  Future<void> cadastrarCompleto(Map<String, dynamic> cadastro) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/cadastro/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cadastro),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Falha ao cadastrar (${response.statusCode}): ${response.body}',
      );
    }
    if (response.body.isEmpty) return;

    final decoded = jsonDecode(response.body);
    if (decoded is Map) {
      final result = Map<String, dynamic>.from(decoded);
      final token = result['access'] ?? result['token'];
      if (token is String && token.isNotEmpty) {
        await storage.write(key: tokenKey, value: token);
      }
    }
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
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Falha na autenticação (${response.statusCode}): ${response.body}',
      );
    }
    if (response.body.isEmpty) {
      throw const FormatException('A API retornou uma resposta vazia.');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const FormatException('A resposta da API não é um objeto JSON.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Future<void> _saveToken(Map<String, dynamic> result) async {
    final value = result['access'] ?? result['token'];
    if (value is String && value.isNotEmpty) {
      await storage.write(key: tokenKey, value: value);
      return;
    }
    throw const FormatException(
      'A API não retornou um token de autenticação.',
    );
  }

  Map<String, dynamic> _userJson(Map<String, dynamic> result) =>
      result['usuario'] is Map
      ? Map<String, dynamic>.from(result['usuario'] as Map)
      : result;
}
