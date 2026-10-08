import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class UsuarioController extends ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService;

  UsuarioController({ApiService? apiService, AuthService? authService})
    : _apiService = apiService ?? ApiService(),
      _authService = authService ?? AuthService();

  UsuarioModel? usuarioAtual;
  bool carregando = false;
  String? erro;
  bool get autenticado => usuarioAtual != null;

  Future<bool> login(String email, String senha) async {
    return _executar(
      () async => usuarioAtual = await _authService.login(email, senha),
    );
  }

  Future<void> carregarPerfilCompleto(String usuarioId) async {
    carregando = true;
    notifyListeners();

    erro = null;
    try {
      usuarioAtual = await _apiService.buscarDadosUsuario(usuarioId);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners(); // Notifica as telas para se redesenharem
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    usuarioAtual = null;
    notifyListeners();
  }

  Future<bool> _executar(Future<void> Function() action) async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      erro = e.toString();
      return false;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
