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
             defaultValue: 'http://127.0.0.1:8000/api',
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
    final dadosCadastro = Map<String, dynamic>.from(cadastro);
    final dadosCamera = dadosCadastro.remove('camera');
    final camera = dadosCamera is Map
        ? Map<String, dynamic>.from(dadosCamera)
        : null;
    if (dadosCamera != null && camera == null) {
      throw const FormatException('Os dados da câmera são inválidos.');
    }
    if (camera != null) {
      final enderecoIp = camera['endereco_ip'];
      if (enderecoIp is! String || enderecoIp.trim().isEmpty) {
        throw const FormatException('O endereço IP da câmera é obrigatório.');
      }
      camera['endereco_ip'] = enderecoIp.trim();
      dadosCadastro['ip_camera'] = enderecoIp.trim();
    }

    final response = await client.post(
      Uri.parse('$baseUrl/auth/cadastro/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dadosCadastro),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Falha ao cadastrar (${response.statusCode}): ${response.body}',
      );
    }
    Map<String, dynamic> resultadoCadastro = {};
    if (response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        resultadoCadastro = Map<String, dynamic>.from(decoded);
      }
    }
    final tokenCadastro = _tokenFrom(resultadoCadastro);
    if (tokenCadastro != null) {
      await storage.write(key: tokenKey, value: tokenCadastro);
    }
    if (camera == null) return;

    final credenciais = <String, dynamic>{
      'email': dadosCadastro['email'],
      'senha': dadosCadastro['senha'],
    };
    final token =
        tokenCadastro ??
        await _saveToken(await _post('/auth/login/', credenciais));

    final responseCamera = await client.post(
      Uri.parse('$baseUrl/camera/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'endereco_ip': camera['endereco_ip'],
        'nome_camara': camera['nome_camara'] ?? camera['nome'],
        'localizacao': camera['localizacao'],
        'modelo': camera['modelo'],
      }),
    );
    if (responseCamera.statusCode < 200 || responseCamera.statusCode >= 300) {
      throw Exception(
        'Falha ao salvar a câmera (${responseCamera.statusCode}): '
        '${responseCamera.body}',
      );
    }
    if (responseCamera.body.isEmpty) {
      throw const FormatException(
        'A API não confirmou o salvamento da câmera.',
      );
    }
    final respostaCamera = jsonDecode(responseCamera.body);
    if (respostaCamera is! Map ||
        respostaCamera['camera'] is! Map ||
        (respostaCamera['camera'] as Map)['endereco_ip'] !=
            camera['endereco_ip']) {
      throw const FormatException(
        'A API não confirmou o endereço IP salvo para a câmera.',
      );
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

  Future<String> _saveToken(Map<String, dynamic> result) async {
    final token = _tokenFrom(result);
    if (token != null) {
      await storage.write(key: tokenKey, value: token);
      return token;
    }
    throw const FormatException('A API não retornou um token de autenticação.');
<<<<<<< HEAD
=======
  }

  Future<Map<String, dynamic>> getDadosApi(String caminho) async {
    final chave = await token;

    if (chave == null || chave.isEmpty) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final response = await client.get(
      Uri.parse('$baseUrl$caminho'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $chave',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao consultar $caminho: '
        '${response.statusCode} - ${response.body}',
      );
    }

    final dados = jsonDecode(response.body);

    if (dados is Map) {
      return Map<String, dynamic>.from(dados);
    }

    throw const FormatException('Resposta inválida da API.');
  }

  Future<Map<String, dynamic>> getPerfil() async {
    return getDadosApi('/perfil/');
  }

  Future<List<dynamic>> getAlertas() async {
    final chave = await token;

    if (chave == null || chave.isEmpty) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/alertas/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $chave',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar alertas: '
        '${response.statusCode} - ${response.body}',
      );
    }

    final dados = jsonDecode(response.body);

    if (dados is List) {
      return dados;
    }

    if (dados is Map && dados['resultados'] is List) {
      return dados['resultados'] as List<dynamic>;
    }

    return [];
  }

  Future<Map<String, dynamic>> getCamera() async {
    return getDadosApi('/camera/');
>>>>>>> 133d3d585491529d23f44476eaca6c2697f6d627
  }

  String? _tokenFrom(Map<String, dynamic> result) {
    final value = result['access'] ?? result['token'];
    return value is String && value.isNotEmpty ? value : null;
  }

  Map<String, dynamic> _userJson(Map<String, dynamic> result) =>
      result['usuario'] is Map
      ? Map<String, dynamic>.from(result['usuario'] as Map)
      : result;
}
