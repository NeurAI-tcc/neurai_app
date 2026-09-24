import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.0.65:8000/api";

  Future<UsuarioModel> buscarDadosUsuario(String usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/usuario/$usuarioId/'));
    
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return UsuarioModel.fromJson(jsonMap);
    } else {
      throw Exception('Falha ao obter dados do usuário');
    }
  }
}