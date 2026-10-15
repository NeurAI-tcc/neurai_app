import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class CadastroCriancaDraft {
  CadastroCriancaDraft({
    required this.nomeCompleto,
    required this.email,
    required this.senha,
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final String nomeCompleto;
  final String email;
  final String senha;
  final AuthService _authService;
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> valores = {
    'condicoes_saude': <String>[],
    'alergias': <String>[],
  };
  final List<XFile> fotos = [];
  XFile? fotoPerfil;
  Uint8List? laudoBytes;
  Map<String, String>? camera;

  void setCamera(Map<String, String> dados) {
    camera = Map.unmodifiable(dados);
  }

  TextEditingController text(String key) =>
      _textControllers.putIfAbsent(key, TextEditingController.new);

  String value(String key) => text(key).text.trim();

  void setValue(String key, dynamic value) {
    valores[key] = value;
  }

  DateTime? date(String key) => valores[key] as DateTime?;

  Future<Map<String, dynamic>> toJson() async => {
    'tipo_usuario': 'Responsavel',
    'nome_completo': nomeCompleto,
    'email': email,
    'senha': senha,
    'valor': 50.0,
    if (camera != null) 'camera': camera,
    'perfil_crianca': {
      'nome_completo': value('crianca_nome'),
      'nome_social': value('nome_social'),
      'data_nascimento': date('data_nascimento')?.toIso8601String(),
      'sexo': valores['sexo'] as String?,
      'diagnostico': valores['diagnostico'] as String?,
      'data_diagnostico': date('data_diagnostico')?.toIso8601String(),
      'nivel_suporte': valores['nivel_suporte'] as String?,
      'frequencia_crises': valores['frequencia_crises'] as String?,
      'condicoes': valores['condicoes_saude'] ?? <String>[],
      'alergias': valores['alergias'] ?? <String>[],
      'usa_medicamentos': valores['usa_medicacao'] ?? false,
      'medicacoes': _medicacoes(value('medicamentos')),
      'possui_crises_epilepticas': valores['possui_crises'] ?? false,
      'comunicacao': valores['comunicacao'] as String?,
      'atividades_favoritas': _splitList(value('atividades_favoritas')),
      'gatilhos': _splitList(value('gatilhos')),
      'o_que_ajuda_acalmar': _splitList(value('o_que_acalma')),
      'horario_acordar': valores['horario_acordar'] as String?,
      'horario_dormir': valores['horario_dormir'] as String?,
      'possui_sonecas': valores['faz_soneca'] ?? false,
      'alimentacao': _splitList(valores['alimentacao'] as String? ?? ''),
      'seletividade_alimentar': valores['seletividade_alimentar'] ?? false,
      'atividades': _splitList(value('atividades_terapeuticas')),
      'observacoes': value('observacoes'),
      'laudo_nome': valores['laudo_nome'] as String?,
      'foto_perfil_url': await _encodeImage(fotoPerfil),
      'foto_frente_url': await _encodePhoto(0),
      'foto_direita_url': await _encodePhoto(1),
      'foto_esquerda_url': await _encodePhoto(2),
      'foto_cima_url': await _encodePhoto(3),
      'foto_baixo_url': await _encodePhoto(4),
      'foto_sorrindo_url': await _encodePhoto(5),
      'laudo_url': laudoBytes == null ? null : base64Encode(laudoBytes!),
    },
  };

  Future<void> salvar() async {
    if (value('crianca_nome').isEmpty) {
      throw StateError('Informe o nome da criança.');
    }
    if (fotos.length != 7) {
      throw StateError('Conclua as sete etapas de captura da câmera.');
    }
    final dadosCamera = camera;
    if (dadosCamera == null ||
        ['endereco_ip', 'nome', 'localizacao', 'modelo'].any(
          (campo) => dadosCamera[campo]?.trim().isNotEmpty != true,
        )) {
      throw StateError('Informe todos os dados da câmera.');
    }

    await _authService.cadastrarCompleto(await toJson());
  }

  Future<String?> _encodePhoto(int index) async =>
      index < fotos.length ? _encodeImage(fotos[index]) : null;

  Future<String?> _encodeImage(XFile? image) async =>
      image == null ? null : base64Encode(await image.readAsBytes());

  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
  }

  List<String> _splitList(String value) => value
      .split(RegExp(r'[,;\n]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  List<Map<String, dynamic>> _medicacoes(String value) => _splitList(value).map(
    (item) {
      final separator = item.indexOf(RegExp(r'\s[-–—]\s'));
      return <String, dynamic>{
        'nome': separator == -1 ? item : item.substring(0, separator).trim(),
        'horario': separator == -1 ? '' : item.substring(separator + 3).trim(),
      };
    },
  ).toList();
}
