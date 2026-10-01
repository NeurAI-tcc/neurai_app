import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class ProfileService {
  final String baseUrl;
  final http.Client client;

  ProfileService({String? baseUrl, http.Client? client})
    : baseUrl = baseUrl ?? 'http://192.168.0.65:8000/api',
      client = client ?? http.Client();

  Future<UsuarioModel> salvarPerfil(
    String usuarioId,
    Map<String, dynamic> dados,
    String token,
  ) async {
    final request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl/usuario/$usuarioId/'))
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['perfil'] = jsonEncode(dados);
    final response = await client.send(request);
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw Exception('Falha ao salvar perfil (${response.statusCode})');
    return UsuarioModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(body) as Map),
    );
  }

  Future<List<String>> uploadFotosReconhecimento(
    String usuarioId,
    List<String> caminhos,
    String token,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/usuario/$usuarioId/reconhecimento-facial/'),
    )..headers['Authorization'] = 'Bearer $token';
    for (final caminho in caminhos) {
      request.files.add(await http.MultipartFile.fromPath('fotos', caminho));
    }
    final response = await client.send(request);
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300)
      throw Exception('Falha ao enviar fotos (${response.statusCode})');
    final json = jsonDecode(body);
    return json is Map && json['fotos_urls'] is List
        ? (json['fotos_urls'] as List).whereType<String>().toList()
        : const [];
  }
}
