import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/api_service.dart';

class UsuarioController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  UsuarioModel? usuarioAtual;
  bool carregando = false;

  Future<void> carregarPerfilCompleto(String usuarioId) async {
    carregando = true;
    notifyListeners();

    try {
      usuarioAtual = await _apiService.buscarDadosUsuario(usuarioId);
    } catch (e) {
      print("Erro ao carregar perfil: $e");
    } finally {
      carregando = false;
      notifyListeners(); // Notifica as telas para se redesenharem
    }
  }
}